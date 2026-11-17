extends TestCase

func run() -> void:
	# Data valid
	var props: Array = DataRegistry.rows("world_props")
	var layout: Array = DataRegistry.rows("world_start_layout")
	check(props.size() == 7, "7 definisi prop")
	check(layout.size() >= 40, "tata letak berisi penempatan (%d)" % layout.size())
	var bad := 0
	for row in layout:
		if not DataRegistry.has_row("world_props", str(row["prop"])):
			bad += 1
		if absf(float(row["x"])) > 29.0 or absf(float(row["z"])) > 29.0:
			bad += 1
		if Vector2(float(row["x"]), float(row["z"])).length() < 3.0 and str(row["prop"]) != "tuft":
			bad += 1
	check_eq(bad, 0, "penempatan valid, di dalam dunia, tidak menimpa titik mulai")
	for p in props:
		check(ResourceLoader.exists(str(p["model"])), "model ada: %s" % p["id"])
		check(bool(p.get("provisional", false)), "prop ditandai sementara: %s" % p["id"])

	GameTime.new_game()
	await SceneManager.go("world_start", true, false)
	await wait_frames(3)
	var world: Node = tree.current_scene
	check_eq(world.name, "WorldStart", "dunia awal aktif")
	check_eq(world.prop_count, layout.size(), "semua prop terpasang")
	check(world.hud.time_text().contains("06:"), "HUD menampilkan waktu awal")

	# Pemain bergerak (physics) dan kamera mengikuti
	var player: PlayerController = world.player
	player.input_override = Vector2(0, -1)
	var z0 := player.global_position.z
	for i in 40:
		await tree.physics_frame
	check(player.global_position.z < z0 - 0.5, "pemain maju ke -Z")
	check(absf(player.global_position.y) < 0.01, "pemain tetap di tanah")
	player.input_override = Vector2.ZERO
	for i in 30:
		await tree.physics_frame
	check(player.velocity.length() < 0.05, "pemain berhenti tanpa input")

	# Tabrakan: pohon menghalangi
	var tree_row: Dictionary = {}
	for row in layout:
		if str(row["prop"]) == "tree_a":
			tree_row = row
			break
	var tpos := Vector3(float(tree_row["x"]), 0, float(tree_row["z"]))
	player.global_position = tpos + Vector3(0, 0, 3.0)
	player.velocity = Vector3.ZERO
	player.camera_yaw_deg = 0.0
	player.input_override = Vector2.ZERO
	await tree.physics_frame
	# arahkan langsung ke pohon: input relatif kamera yaw 0, maju = -Z
	var dir := (tpos - player.global_position)
	# yaw kamera diatur agar "maju" mengarah ke pohon
	player.camera_yaw_deg = -rad_to_deg(atan2(-dir.x, -dir.z))
	player.input_override = Vector2(0, -1)
	for i in 120:
		await tree.physics_frame
	var dist := Vector2(player.global_position.x - tpos.x, player.global_position.z - tpos.z).length()
	check(dist > 0.45, "pemain tidak menembus batang pohon (jarak %.2f)" % dist)
	check(dist < 2.0, "pemain mendekati pohon (jarak %.2f)" % dist)

	# Interaksi dengan pohon
	player.input_override = Vector2.ZERO
	await wait_frames(3)
	world.sensor.facing = (tpos - player.global_position).normalized()
	check(world.sensor.refresh() != null, "pohon terdeteksi sebagai target")
	check(world.sensor.try_interact(), "interaksi dengan pohon")
	check_eq(world.inspect_count(), 1, "interaksi tercatat")

	# Pertanian: petak di dunia, aksi lewat sensor interaksi
	check_eq(world.plot_nodes.size(), 12, "12 petak lahan terpasang")
	var plot_node: Node3D = world.plot_nodes["plot_01"]
	player.global_position = plot_node.global_position + Vector3(0, 0, 1.2)
	await wait_frames(2)
	world.sensor.facing = Vector3(0, 0, -1)
	var target: Interactable = world.sensor.refresh()
	check(target != null and target.has_meta("plot_id"), "petak terdeteksi sebagai target")
	check(world.sensor.try_interact(), "cangkul petak lewat interaksi")
	check(world.farming.grid.plot("plot_01").tilled, "petak tergemburkan")
	check(world.sensor.try_interact(), "tanam lewat interaksi")
	check(world.farming.grid.plot("plot_01").has_crop(), "tanaman tertanam")
	check(world.inventory_text().contains("x5"), "HUD tas menampilkan benih berkurang")
	check(world.get_node("FarmPlots/plot_01/CropMarker").visible, "penanda tanaman tampil")

	# Tempat tidur: tidur lewat interaksi, bangun hari berikutnya
	check(world.vitality_text().contains("HP 100/100"), "HUD menampilkan vitalitas")
	var bed: Node3D = world.get_node("Bed")
	player.global_position = bed.global_position + Vector3(0, 0, 1.2)
	await wait_frames(2)
	world.sensor.facing = Vector3(0, 0, -1)
	var day0 := GameTime.clock.day_index()
	world.farming.vitality.change("stamina", -10)
	check(world.sensor.try_interact(), "interaksi tempat tidur")
	check(world.farming.sleep.is_sleeping(), "mulai tidur")
	var frames := 0
	while world.farming.sleep.is_sleeping() and frames < 200:
		await tree.process_frame
		frames += 1
	check(not world.farming.sleep.is_sleeping(), "tidur selesai (%d frame)" % frames)
	check(frames > 2, "pemrosesan lebih dari satu frame")
	check_eq(GameTime.clock.day_index(), day0 + 1, "hari berganti setelah tidur")
	check_eq(world.farming.vitality.value("stamina"), 20, "stamina pulih")

	# NPC uji: posisi jadwal, dialog, hubungan, waktu berhenti saat bicara
	check_eq(world.npc_nodes.size(), 2, "2 NPC uji terpasang")
	world.snap_npcs()
	var npc_a: Node3D = world.npc_nodes["npc_test_a"]
	var exp_loc := Vector3(float(DataRegistry.get_row("npc_locations", world.npc_state("npc_test_a")["location"])["x"]), 0.0, float(DataRegistry.get_row("npc_locations", world.npc_state("npc_test_a")["location"])["z"]))
	check(npc_a.position.distance_to(exp_loc) < 0.01, "NPC berada di lokasi jadwal")
	world.farming.world_seed = 1
	while world.farming.is_raining_today():
		world.farming.world_seed += 1
	player.global_position = npc_a.global_position + Vector3(0, 0, 1.2)
	await wait_frames(2)
	world.sensor.facing = Vector3(0, 0, -1)
	var tgt: Interactable = world.sensor.refresh()
	check(tgt != null and tgt.has_meta("npc_id"), "NPC terdeteksi sebagai target")
	var minute_before := GameTime.clock.total_minutes
	check(world.sensor.try_interact(), "mulai bicara")
	check(world.dialog.is_active() and world.hud.dialog_visible(), "dialog tampil")
	check(GameTime.clock.is_paused(), "waktu berhenti saat dialog")
	await wait_frames(5)
	check_eq(GameTime.clock.total_minutes, minute_before, "jam tidak maju saat dialog")
	world.hud.dialog_next.emit()
	world.hud.dialog_choice.emit(0)
	check_eq(world.social.friendship("npc_test_a"), 2, "friendship bertambah lewat UI")
	world.hud.dialog_next.emit()
	check(not world.dialog.is_active() and not world.hud.dialog_visible(), "dialog ditutup")
	check(not GameTime.clock.is_paused(), "waktu berjalan lagi")
	# Jadwal berubah menurut jam: NPC bergerak ke lokasi baru
	GameTime.clock.add_minutes(7 * 60)
	await wait_frames(2)
	var tgt_after: Vector3 = world._npc_targets["npc_test_a"]
	check(tgt_after.distance_to(exp_loc) > 1.0, "target NPC berubah menurut jadwal")
	var d0 := npc_a.position.distance_to(tgt_after)
	await wait_frames(20)
	check(npc_a.position.distance_to(tgt_after) < d0, "NPC bergerak menuju lokasi baru")

	# Memancing lewat interaksi
	world.farming.vitality.restore_full("stamina")
	player.global_position = Vector3(13.6, 0, 4.0)
	await wait_frames(2)
	world.sensor.facing = Vector3(1, 0, 0)
	var spot: Interactable = world.sensor.refresh()
	check(spot != null and spot.has_meta("spot_id"), "kolam terdeteksi")
	check(world.sensor.try_interact(), "mulai memancing")
	check(world.cast != null, "lemparan aktif")
	var guard := 0
	while world.cast != null and world.cast.state == FishingCast.WAITING and guard < 200:
		world.cast.advance(0.1)
		guard += 1
	check(world.cast.state == FishingCast.BITE, "gigitan datang")
	var fish_before: int = world.farming.inventory.count("fish_test_a") + world.farming.inventory.count("fish_test_b") + world.farming.inventory.count("fish_test_c")
	check(world.sensor.try_interact(), "tarik pancing")
	check(world.cast == null, "lemparan selesai")
	var fish_after: int = world.farming.inventory.count("fish_test_a") + world.farming.inventory.count("fish_test_b") + world.farming.inventory.count("fish_test_c")
	check_eq(fish_after, fish_before + 1, "ikan masuk tas")

	# Peternakan lewat interaksi
	var pen: Node3D = world.animal_nodes["pen_01"]
	player.global_position = pen.global_position + Vector3(0, 0, 1.2)
	await wait_frames(2)
	world.sensor.facing = Vector3(0, 0, -1)
	var an_target: Interactable = world.sensor.refresh()
	check(an_target != null and an_target.has_meta("animal_id"), "hewan terdeteksi")
	var feed_before: int = world.farming.inventory.count("feed_test")
	check(world.sensor.try_interact(), "beri pakan lewat interaksi")
	check_eq(world.farming.inventory.count("feed_test"), feed_before - 1, "pakan berkurang")
	check(world.farming.livestock.animals["pen_01"].fed, "hewan kenyang")

	# Simpan / muat dan tas
	var pm := GameTime.clock.total_minutes
	check(world.save_game(), "simpan slot 0")
	GameTime.clock.add_minutes(120)
	world.farming.act_on("plot_01")  # siram
	world.farming.inventory.clear()
	check(world.load_game(), "muat slot 0")
	check_eq(GameTime.clock.total_minutes, pm, "waktu kembali ke saat disimpan")
	check(world.farming.inventory.count("seed_test_a") == 5, "inventory dipulihkan")
	check(world.farming.grid.plot("plot_01").has_crop(), "petak dipulihkan")
	check(not world.hud.bag_visible(), "tas awalnya tertutup")
	world.hud.toggle_bag()
	check(world.hud.bag_visible(), "tas terbuka")
	world.hud.toggle_bag()
	SaveService.delete_slot(0)
	check(not world.load_game(), "muat tanpa simpanan ditolak")

	# Batas dunia
	player.global_position = Vector3(28, 0, 0)
	player.input_override = Vector2(1, 0)  # kanan relatif yaw 0 = +X (menuju batas)
	player.camera_yaw_deg = 0.0
	for i in 120:
		await tree.physics_frame
	check(player.global_position.x < 30.1, "pemain tidak keluar dari dunia (x=%.2f)" % player.global_position.x)
	player.input_override = null

	# Tata letak HUD
	var vp := tree.root.get_visible_rect()
	check(vp.encloses(world.hud.joystick().get_global_rect()), "joystick HUD di dalam layar")
	check(vp.encloses(world.hud.interact_button().get_global_rect()), "tombol interaksi HUD di dalam layar")

	await SceneManager.go("main_menu", false, false)
	GameTime.new_game()
