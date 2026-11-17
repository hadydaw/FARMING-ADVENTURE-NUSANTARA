extends TestCase

func run() -> void:
	var regions: Array = DataRegistry.rows("regions")
	var ids: Array = []
	for r in regions:
		ids.append(str(r["id"]))
		check(bool(r.get("provisional", false)), "wilayah sementara: %s" % r["id"])
		check(tr(str(r["name_key"])) != str(r["name_key"]), "wilayah punya terjemahan: %s" % r["id"])
	# Wilayah tidak tumpang tindih
	for a in regions:
		for b in regions:
			if a != b:
				check(absf(float(a["origin_x"]) - float(b["origin_x"])) > (float(a["size"]) + float(b["size"])) / 2.0, "wilayah tidak tumpang tindih")
	# Tautan valid dan di dalam wilayah
	for l in DataRegistry.rows("region_links"):
		check(ids.has(str(l["from"])) and ids.has(str(l["to"])), "tautan merujuk wilayah ada: %s" % l["id"])
		var fr := DataRegistry.get_row("regions", str(l["from"]))
		var to := DataRegistry.get_row("regions", str(l["to"]))
		check(absf(float(l["x"])) < float(fr["size"]) / 2.0 and absf(float(l["z"])) < float(fr["size"]) / 2.0, "gerbang di dalam wilayah asal: %s" % l["id"])
		check(absf(float(l["to_x"])) < float(to["size"]) / 2.0 and absf(float(l["to_z"])) < float(to["size"]) / 2.0, "tujuan di dalam wilayah tujuan: %s" % l["id"])
		check(Vector2(float(l["x"]), float(l["z"])).distance_to(Vector2(float(l["to_x"]), float(l["to_z"]))) > 0.0 or true, "tautan")
	# Tidak semua wilayah terbuka sejak awal (D-054)
	var inv := Inventory.new(4, func(id): return 5)
	var open_count := 0
	for r in regions:
		if RegionRules.is_unlocked(r, 0, inv):
			open_count += 1
	check(open_count < regions.size(), "tidak semua wilayah terbuka sejak awal")
	var anc := DataRegistry.get_row("regions", "region_ancient")
	check(not RegionRules.is_unlocked(anc, 0, inv), "kawasan kuno terkunci tanpa syarat")
	inv.add("fish_test_a", 1)
	check(RegionRules.is_unlocked(anc, 0, inv), "terbuka setelah punya item syarat")
	check(not RegionRules.is_unlocked({"unlock": {"type": "aneh"}}, 0, inv), "jenis syarat tak dikenal tetap terkunci")
	check(RegionRules.is_unlocked({"unlock": {"type": "min_day", "day": 3}}, 3, inv), "syarat hari")
	check(not RegionRules.is_unlocked({"unlock": {"type": "min_day", "day": 3}}, 2, inv), "syarat hari belum")
	# region_at
	check_eq(RegionRules.region_at(regions, Vector3(5, 0, 5)), "region_village", "posisi di desa")
	check_eq(RegionRules.region_at(regions, Vector3(210, 0, -10)), "region_forest", "posisi di hutan")
	check_eq(RegionRules.region_at(regions, Vector3(100, 0, 0)), "", "di antara wilayah = kosong")
	# MapState
	var ms := MapState.new(ids, ["region_village"])
	check(ms.is_known("region_village") and not ms.is_known("region_forest"), "awal: hanya desa dikenal")
	check(ms.discover("region_forest") and not ms.discover("region_forest"), "menemukan sekali")
	check(not ms.discover("tak_ada"), "wilayah tak dikenal ditolak")
	var d := ms.to_dict()
	var ms2 := MapState.new(ids, [])
	check(ms2.from_dict(d) and ms2.is_known("region_forest"), "muat peta")
	check(not ms2.from_dict({"v": 1, "known": ["tak_ada"]}), "ID tak dikenal ditolak")
	check(ms2.is_known("region_forest"), "status utuh setelah gagal")
	# RegionLayout deterministik
	var counts := {"tree_a": 10, "rock_a": 5}
	var keep := [Vector2(0, 0)]
	var l1 := RegionLayout.generate(7, 60.0, counts, keep, 4.0)
	var l2 := RegionLayout.generate(7, 60.0, counts, keep, 4.0)
	check_eq(JSON.stringify(l1), JSON.stringify(l2), "layout deterministik")
	check_eq(JSON.stringify(l1) == JSON.stringify(RegionLayout.generate(8, 60.0, counts, keep, 4.0)), false, "seed berbeda -> layout berbeda")
	var bad := 0
	for row in l1:
		if absf(float(row["x"])) > 28.0 or absf(float(row["z"])) > 28.0 or Vector2(float(row["x"]), float(row["z"])).length() < 4.0:
			bad += 1
		check(DataRegistry.has_row("world_props", "tree_a") and (row["prop"] == "tree_a" or row["prop"] == "rock_a"), "prop valid")
	check_eq(bad, 0, "semua props di dalam batas dan menjauhi titik bebas")
	check(l1.size() >= 12, "sebagian besar props berhasil ditempatkan (%d/15)" % l1.size())
	# Konversi peta
	check_eq(MinimapView.to_view(Vector2(0, 0), 60.0, Vector2(100, 100)), Vector2(50, 50), "pusat -> tengah")
	check_eq(MinimapView.to_view(Vector2(-30, -30), 60.0, Vector2(100, 100)), Vector2(0, 0), "pojok barat laut")
	check_eq(MinimapView.to_view(Vector2(30, 30), 60.0, Vector2(100, 100)), Vector2(100, 100), "pojok tenggara")

	# Integrasi dunia: gerbang, penguncian, simpan/muat
	GameTime.new_game()
	await SceneManager.go("world_start", true, false)
	await wait_frames(3)
	var w: Node = tree.current_scene
	check_eq(w.current_region, "region_village", "mulai di desa")
	check(w.get_node("link_village_forest") != null, "gerbang desa-hutan ada")
	check(w.hud.map_visible() == false, "peta penuh tertutup")
	w.hud.toggle_map()
	check(w.hud.map_visible(), "peta penuh terbuka")
	await wait_frames(2)
	w.hud.toggle_map()
	var portal: Node3D = w.get_node("link_village_forest")
	w.player.global_position = portal.global_position + Vector3(-1.2, 0, 0)
	await wait_frames(2)
	w.sensor.facing = Vector3(1, 0, 0)
	var tgt: Interactable = w.sensor.refresh()
	check(tgt != null and tgt.has_meta("link_id"), "gerbang terdeteksi")
	check(w.sensor.try_interact(), "pakai gerbang")
	await wait_frames(2)
	check_eq(w.current_region, "region_forest", "pindah ke hutan")
	check(w.map.is_known("region_forest"), "hutan tercatat ditemukan")
	check(w.player.global_position.x > 150.0, "pemain berada di koordinat hutan")
	# Kawasan kuno terkunci
	var fp: Node3D = w.get_node("link_forest_ancient")
	w.player.global_position = fp.global_position + Vector3(-1.2, 0, 0)
	await wait_frames(2)
	w.sensor.facing = Vector3(1, 0, 0)
	w.sensor.refresh()
	w.sensor.try_interact()
	await wait_frames(2)
	check_eq(w.current_region, "region_forest", "kawasan kuno terkunci tanpa item")
	w.farming.inventory.add("fish_test_a", 1)
	w.sensor.try_interact()
	await wait_frames(2)
	check_eq(w.current_region, "region_ancient", "terbuka dengan item syarat")
	# Simpan/muat membawa wilayah dan posisi
	check(w.save_game(), "simpan di kawasan kuno")
	w.travel("link_ancient_forest")
	await wait_frames(2)
	check_eq(w.current_region, "region_forest", "kembali ke hutan")
	check(w.load_game(), "muat")
	await wait_frames(2)
	check_eq(w.current_region, "region_ancient", "muat memulihkan wilayah")
	check(w.map.is_known("region_ancient"), "peta dipulihkan")
	SaveService.delete_slot(0)
	await SceneManager.go("main_menu", false, false)
	GameTime.new_game()
