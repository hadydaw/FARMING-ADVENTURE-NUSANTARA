extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"gather_nodes": DataRegistry.rows("gather_nodes"), "recipes": DataRegistry.rows("recipes"), "stations": DataRegistry.rows("crafting_stations")})


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	var stations := {}
	for st in DataRegistry.rows("crafting_stations"):
		stations[str(st["id"])] = true
	for r in DataRegistry.rows("recipes"):
		check(bool(r.get("provisional", false)) and stations.has(str(r["station"])), "resep sementara, stasiun ada: %s" % r["id"])
		check(items.has(str(r["output"]["item"])), "hasil resep ada: %s" % r["id"])
		for i in r["inputs"]:
			check(items.has(str(i["item"])), "bahan ada: %s" % i["item"])
		check(tr(str(r["name_key"])) != str(r["name_key"]), "terjemahan resep %s" % r["id"])
	for g in DataRegistry.rows("gather_nodes"):
		check(items.has(str(g["item"])) and int(g["respawn_days"]) > 0, "node kumpul valid: %s" % g["id"])

	var s := _session()
	# Craft tanpa bahan ditolak, tas tidak berubah
	check_eq(str(s.craft("recipe_meal_b")["reason"]), "no_material", "tanpa bahan")
	check_eq(str(s.craft("tidak_ada")["reason"]), "unknown", "resep tak dikenal")
	s.inventory.add("produce_test_b", 2)
	var r := s.craft("recipe_meal_b")
	check(bool(r["ok"]), "craft berhasil")
	check_eq(s.inventory.count("produce_test_b"), 1, "bahan berkurang")
	check_eq(s.inventory.count("meal_test_b"), 1, "hasil masuk")

	# Pakai item: makanan menambah stamina; penuh -> ditolak tanpa konsumsi
	s.vitality.change("stamina", -15)
	var u := s.use_item("meal_test_b")
	check(bool(u["ok"]), "pakai makanan")
	check_eq(s.vitality.value("stamina"), 20, "stamina naik, dibatasi maksimum")
	s.inventory.add("meal_test_b", 1)
	check_eq(str(s.use_item("meal_test_b")["reason"]), "already_full", "sudah penuh")
	check_eq(s.inventory.count("meal_test_b"), 1, "item tidak terpakai bila ditolak")
	check_eq(str(s.use_item("seed_test_a")["reason"]), "not_usable", "bukan consumable")
	check_eq(str(s.use_item("potion_test_health")["reason"]), "no_item", "tidak punya item")

	# Kumpul: tunda respawn per hari
	var gid := str(DataRegistry.rows("gather_nodes")[0]["id"])
	var g1 := s.gather_at(gid)
	check(bool(g1["ok"]), "kumpul pertama")
	check(not bool(s.gather_at(gid)["ok"]), "belum respawn")
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat ulang")
	check(not bool(s2.gather_at(gid)["ok"]), "status kumpul tersimpan")
	check_eq(s2.inventory.count("meal_test_b"), s.inventory.count("meal_test_b"), "tas tersimpan")
