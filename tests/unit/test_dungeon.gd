extends TestCase

func _session(seed_value: int = 1) -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], seed_value, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"quests": DataRegistry.rows("quests"), "guild_config": DataRegistry.get_row("guild_config", "default"), "dungeons": DataRegistry.rows("dungeons")})


func _strong(s: FarmingSession) -> void:
	s.inventory.add("weapon_test_sword", 1)
	s.combat.exp_total = 300   # level tinggi
	s.vitality.change("stamina", 100)


func run() -> void:
	var mons := {}
	for m in DataRegistry.rows("monsters"):
		mons[str(m["id"])] = m
	for d in DataRegistry.rows("dungeons"):
		check(bool(d.get("provisional", false)) and int(d["rooms"]) >= 2 and mons.has(str(d["boss"])), "dungeon valid")
		for p in d["pool"]:
			check(mons.has(str(p)), "kolam ada")
		check(tr(str(d["name_key"])) != str(d["name_key"]), "terjemahan")

	var s := _session()
	var dg := s.dungeon
	check_eq(str(s.dungeon_attack()["reason"]), "not_running", "serang tanpa run")
	check(bool(s.dungeon_start("dungeon_test")["ok"]), "mulai")
	check_eq(str(s.dungeon_start("dungeon_test")["reason"]), "running", "tidak dobel")
	check_eq(dg.room_count(), 3, "3 ruangan")
	check(str(dg.to_dict()["rooms"][2]) == "monster_boss_test", "ruang terakhir bos")
	# Deterministik
	var s2 := _session()
	s2.dungeon_start("dungeon_test")
	check_eq(JSON.stringify(s2.dungeon.to_dict()), JSON.stringify(dg.to_dict()), "ruangan deterministik")
	# Selesaikan dengan pemain kuat
	_strong(s)
	var money := s.economy.money
	var cleared := false
	for i in 200:
		s.vitality.change("health", 100)
		s.vitality.change("stamina", 100)
		var r := s.dungeon_attack()
		if bool(r["cleared"]):
			cleared = true
			break
	check(cleared, "gua selesai")
	check(not dg.running(), "run berakhir")
	check_eq(s.economy.money, money + 200, "hadiah uang")
	check(s.inventory.count("drop_test_hide") >= 3, "drop bos")
	check_eq(str(s.dungeon_start("dungeon_test")["reason"]), "cooldown", "masih tertutup")
	# Simpan/muat termasuk run berjalan
	var s3 := _session()
	s3.dungeon_start("dungeon_test")
	var saved := s3.to_dict()
	var s4 := _session()
	check(s4.from_dict(saved), "muat run")
	check_eq(JSON.stringify(s4.dungeon.to_dict()), JSON.stringify(s3.dungeon.to_dict()), "run tersimpan")
	var bad := saved.duplicate(true)
	bad["dungeon"]["rooms"] = ["palsu"]
	var s5 := _session()
	s5.dungeon_start("dungeon_test")
	var before := JSON.stringify(s5.dungeon.to_dict())
	check(not s5.from_dict(bad), "data rusak ditolak")
	check_eq(JSON.stringify(s5.dungeon.to_dict()), before, "rollback")
	# Pingsan: pemain lemah
	var w := _session()
	w.dungeon_start("dungeon_test")
	w.vitality.change("health", -(w.vitality.value("health") - 3))
	var fr := w.dungeon_attack()
	check(bool(fr["fainted"]) or int(fr["taken"]) == 0, "pingsan bila HP rendah")
	if bool(fr["fainted"]):
		check(not w.dungeon.running(), "run berakhir saat pingsan")
	# Keluar
	var l := _session()
	l.dungeon_start("dungeon_test")
	l.dungeon.leave()
	check(not l.dungeon.running(), "keluar")
	check(l.dungeon_start("dungeon_test")["ok"], "bisa mulai lagi setelah keluar")
