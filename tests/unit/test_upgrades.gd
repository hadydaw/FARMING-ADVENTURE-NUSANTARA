extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"upgrades": DataRegistry.rows("upgrades")})


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	var ids := {}
	for u in DataRegistry.rows("upgrades"):
		ids[str(u["id"])] = true
	for u in DataRegistry.rows("upgrades"):
		check(bool(u.get("provisional", false)) and int(u["cost"]) >= 0, "upgrade sementara valid: %s" % u["id"])
		check(str(u["requires"]) == "" or ids.has(str(u["requires"])), "syarat ada")
		for m in u["materials"]:
			check(items.has(str(m["item"])), "bahan ada")
		check(tr(str(u["name_key"])) != str(u["name_key"]), "terjemahan")

	var s := _session()
	var base_slots := s.inventory.slot_count
	var max_stam := s.vitality.max_value("stamina")
	check_eq(str(s.upgrade_buy("up_bag_2")["reason"]), "locked", "syarat belum dipenuhi")
	check_eq(str(s.upgrade_buy("palsu")["reason"]), "unknown", "tak dikenal")
	s.economy.money = 10
	check_eq(str(s.upgrade_buy("up_bag_1")["reason"]), "no_money", "uang kurang")
	s.economy.money = 1000
	check_eq(str(s.upgrade_buy("up_bag_1")["reason"]), "no_material", "bahan kurang")
	check_eq(s.economy.money, 1000, "gagal beli tidak memotong uang")
	s.inventory.add("material_stone_test", 10)
	check(bool(s.upgrade_buy("up_bag_1")["ok"]), "beli tas")
	check_eq(s.inventory.slot_count, base_slots + 6, "slot bertambah")
	check_eq(s.inventory.slots().size(), base_slots + 6, "array slot bertambah")
	check_eq(s.economy.money, 900, "uang dikurangi")
	check_eq(s.inventory.count("material_stone_test"), 8, "bahan dikurangi")
	check_eq(str(s.upgrade_buy("up_bag_1")["reason"]), "owned", "tidak dobel")
	check(bool(s.upgrade_buy("up_bag_2")["ok"]), "beli tas II setelah syarat")
	check_eq(s.inventory.slot_count, base_slots + 12, "slot 12 tambahan")
	# Meter
	s.inventory.add("herb_test", 3)
	check(bool(s.upgrade_buy("up_stamina_1")["ok"]), "beli stamina")
	check_eq(s.vitality.max_value("stamina"), max_stam + 10, "stamina maks naik")
	# Simpan/muat ke sesi baru (ukuran tas & meter harus cocok)
	s.inventory.add("seed_test_a", 3)
	var seeds_saved := s.inventory.count("seed_test_a")
	s.vitality.change("stamina", 100)
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat sesi baru")
	check_eq(s2.inventory.slot_count, base_slots + 12, "ukuran tas dipulihkan")
	check_eq(s2.vitality.max_value("stamina"), max_stam + 10, "meter maks dipulihkan")
	check_eq(s2.vitality.value("stamina"), max_stam + 10, "nilai meter dipulihkan")
	check_eq(s2.inventory.count("seed_test_a"), seeds_saved, "isi tas dipulihkan")
	# Muat save tanpa upgrade ke sesi yang punya upgrade: kembali ke dasar
	var plain := _session().to_dict()
	check(s.from_dict(plain), "muat save tanpa upgrade")
	check_eq(s.inventory.slot_count, base_slots, "tas kembali ke dasar")
	check_eq(s.vitality.max_value("stamina"), max_stam, "meter kembali ke dasar")
	# Data rusak: rollback utuh
	var s3 := _session()
	s3.economy.money = 1000
	s3.inventory.add("material_stone_test", 5)
	s3.upgrade_buy("up_bag_1")
	var before := JSON.stringify(s3.to_dict())
	var bad := saved.duplicate(true)
	bad["inventory"]["slots"] = []
	check(not s3.from_dict(bad), "save rusak ditolak")
	check_eq(JSON.stringify(s3.to_dict()), before, "rollback utuh termasuk upgrade")
	check_eq(s3.inventory.slot_count, base_slots + 6, "ukuran tas tetap")
	var bad2 := saved.duplicate(true)
	bad2["upgrades"]["owned"] = ["up_bag_2"]   # tanpa syarat
	check(not s3.from_dict(bad2), "upgrade tanpa syarat ditolak")
	check_eq(JSON.stringify(s3.to_dict()), before, "rollback utuh (2)")
