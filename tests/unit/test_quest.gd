extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"quests": DataRegistry.rows("quests"), "guild_config": DataRegistry.get_row("guild_config", "default")})


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	var mons := {}
	for m in DataRegistry.rows("monsters"):
		mons[str(m["id"])] = true
	for q in DataRegistry.rows("quests"):
		check(bool(q.get("provisional", false)) and int(q["count"]) > 0, "quest sementara valid: %s" % q["id"])
		check(items.has(str(q["target"])) if str(q["type"]) == "collect" else mons.has(str(q["target"])), "target ada: %s" % q["id"])
		check(tr(str(q["name_key"])) != str(q["name_key"]), "terjemahan quest")
		for it in q["reward"].get("items", []):
			check(items.has(str(it["item"])), "hadiah item ada")
	for r in DataRegistry.get_row("guild_config", "default")["ranks"]:
		check(tr(str(r["name_key"])) != str(r["name_key"]), "terjemahan peringkat")

	var s := _session()
	var q := s.quests
	check_eq(q.rank(), 0, "peringkat awal")
	check_eq(q.status("quest_collect_herb", s.inventory), "new", "tersedia")
	check_eq(q.status("quest_collect_goo", s.inventory), "locked", "peringkat kurang")
	check_eq(str(s.quest_accept("quest_collect_goo")["reason"]), "locked", "tolak terkunci")
	check_eq(str(s.quest_accept("palsu")["reason"]), "unknown", "tak dikenal")
	check(bool(s.quest_accept("quest_collect_herb")["ok"]), "terima")
	check_eq(str(s.quest_accept("quest_collect_herb")["reason"]), "taken", "tidak dobel")
	check(bool(s.quest_accept("quest_defeat_slime")["ok"]), "terima kedua")
	check_eq(q.active_count(), 2, "dua aktif")
	check_eq(str(s.quest_turn_in("quest_collect_herb")["reason"]), "not_ready", "belum memenuhi")
	# Collect
	s.inventory.add("herb_test", 3)
	check_eq(q.status("quest_collect_herb", s.inventory), "ready", "siap diserahkan")
	var money := s.economy.money
	check(bool(s.quest_turn_in("quest_collect_herb")["ok"]), "serahkan collect")
	check_eq(s.inventory.count("herb_test"), 0, "bahan dikonsumsi")
	check_eq(s.economy.money, money + 40, "uang hadiah")
	check_eq(s.combat.exp_total, 6, "EXP hadiah")
	check_eq(q.points, 1, "poin guild")
	check_eq(q.status("quest_collect_herb", s.inventory), "done", "selesai")
	# Defeat: hanya hitung setelah diterima
	var s2 := _session()
	for i in 8:
		s2.attack_monster("ms_forest_1")   # bunuh sebelum terima quest (tidak dihitung)
	check(bool(s2.quest_accept("quest_defeat_slime")["ok"]), "terima setelah bunuh")
	check_eq(q.progress("quest_defeat_slime", s.inventory), 0, "progres awal 0")
	check_eq(s2.quests.progress("quest_defeat_slime", s2.inventory), 0, "bunuh lama tak dihitung")
	s2.combat._dead_day.clear()
	s2.combat._hp.clear()
	for i in 8:
		s2.attack_monster("ms_forest_1")
	check_eq(s2.quests.progress("quest_defeat_slime", s2.inventory), 1, "progres bertambah")
	# Peringkat naik dari poin
	s2.quests.points = 3
	check_eq(s2.quests.rank(), 1, "peringkat naik")
	check_eq(s2.quests.status("quest_collect_goo", s2.inventory), "new", "quest peringkat 1 terbuka")
	# Hadiah item + tas penuh -> batal tanpa efek
	var s3 := _session()
	s3.quests.points = 3
	s3.quest_accept("quest_collect_goo")
	s3.inventory.add("drop_test_goo", 2)
	for i in 30:
		s3.inventory.add("seed_test_a", 20)
		s3.inventory.add("seed_test_b", 20)
		s3.inventory.add("produce_test_a", 20)
		s3.inventory.add("produce_test_b", 20)
	var snap := JSON.stringify(s3.inventory.to_dict())
	var money3 := s3.economy.money
	var rr := s3.quest_turn_in("quest_collect_goo")
	if not bool(rr["ok"]):
		check_eq(str(rr["reason"]), "inventory_full", "tas penuh")
		check_eq(JSON.stringify(s3.inventory.to_dict()), snap, "tas tak berubah")
		check_eq(s3.economy.money, money3, "uang tak berubah")
	# Simpan/muat + rollback
	var saved := s.to_dict()
	var s4 := _session()
	check(s4.from_dict(saved), "muat")
	check_eq(s4.quests.points, 1, "poin tersimpan")
	check_eq(s4.quests.status("quest_collect_herb", s4.inventory), "done", "status selesai tersimpan")
	var bad := saved.duplicate(true)
	bad["quests"]["active"] = {"palsu": 1}
	var s5 := _session()
	s5.quests.points = 2
	check(not s5.from_dict(bad), "data quest rusak ditolak")
	check_eq(s5.quests.points, 2, "rollback utuh")
