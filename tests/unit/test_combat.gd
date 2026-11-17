extends TestCase

func _session(seed_value: int = 1) -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], seed_value, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices")})


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	var mons := {}
	for m in DataRegistry.rows("monsters"):
		mons[str(m["id"])] = true
		check(bool(m.get("provisional", false)) and int(m["hp"]) > 0 and int(m["exp"]) > 0, "monster valid: %s" % m["id"])
		check(tr(str(m["name_key"])) != str(m["name_key"]), "terjemahan monster")
		for d in m["drops"]:
			check(items.has(str(d["item"])) and float(d["chance"]) > 0.0 and float(d["chance"]) <= 1.0, "drop valid")
	var regions := {}
	for r in DataRegistry.rows("regions"):
		regions[str(r["id"])] = true
	for sp in DataRegistry.rows("monster_spawns"):
		check(mons.has(str(sp["monster"])) and regions.has(str(sp["region"])), "spawn valid: %s" % sp["id"])

	var s := _session()
	var sid := "ms_forest_1"   # slime: hp 12, atk 3, def 0
	check_eq(s.combat.level(), 1, "level awal 1")
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), 3, "serangan dasar")
	s.inventory.add("weapon_test_sword", 1)
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), 7, "pedang menambah serangan")
	check_eq(str(s.attack_monster("tidak_ada")["reason"]), "unknown", "spawn tak dikenal")
	var stam := s.vitality.value("stamina")
	var r1 := s.attack_monster(sid)
	check(bool(r1["ok"]) and int(r1["dealt"]) == 7 and not bool(r1["defeated"]), "serangan pertama")
	check_eq(int(r1["taken"]), 3, "dibalas monster")
	check_eq(s.vitality.value("stamina"), stam - 1, "biaya stamina")
	check_eq(s.combat.hp_of(sid, 0), 5, "HP monster turun")
	var r2 := s.attack_monster(sid)
	check(bool(r2["defeated"]) and int(r2["exp"]) == 5, "monster kalah")
	check_eq(int(r2["taken"]), 0, "monster mati tidak membalas")
	check_eq(s.combat.exp_total, 5, "EXP bertambah")
	check_eq(s.combat.kills, 1, "jumlah kalahkan")
	check_eq(str(s.attack_monster(sid)["reason"]), "not_here", "tidak bisa serang lagi hari ini")
	check(s.combat.is_alive(sid, 1), "bangkit setelah respawn_days")

	# Deterministik: seed sama -> drop sama
	var a := _session(7)
	var b := _session(7)
	for i in 2:
		a.attack_monster(sid)
		b.attack_monster(sid)
	check_eq(JSON.stringify(a.inventory.to_dict()), JSON.stringify(b.inventory.to_dict()), "drop deterministik per seed")

	# Tas penuh: drop dilewati tanpa merusak
	# Kelelahan
	var t := _session()
	t.vitality.change("stamina", -100)
	var rt := t.attack_monster(sid)
	check_eq(str(rt["reason"]), "too_tired", "terlalu lelah")
	check_eq(t.combat.hp_of(sid, 0), 12, "gagal serang tidak mengubah monster")

	# Pingsan: babi (atk 6) mengalahkan pemain tanpa pelindung; uang berkurang, HP pulih separuh, monster pulih
	var f := _session()
	f.economy.money = 100
	f.vitality.change("health", -(f.vitality.value("health") - 5))
	var fr := f.attack_monster("ms_forest_3")
	check(bool(fr["fainted"]), "pingsan")
	check_eq(f.economy.money, 90, "uang berkurang 10%")
	check_eq(f.vitality.value("health"), 50, "HP pulih separuh")
	check_eq(f.combat.hp_of("ms_forest_3", 0), 30, "monster pulih penuh")

	# Level naik dari EXP
	var lv := _session()
	lv.combat.exp_total = 19
	var leveled := false
	for i in 6:
		var lr := lv.attack_monster(sid)
		leveled = leveled or bool(lr.get("leveled", false))
	check(leveled, "naik level")
	check_eq(lv.combat.level(), 2, "level 2")
	check_eq(lv.combat.player_attack(lv.inventory, lv.item_defs), 4, "level menambah serangan")

	# Simpan/muat dan rollback
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat")
	check_eq(s2.combat.exp_total, 5, "EXP tersimpan")
	check(not s2.combat.is_alive(sid, 0), "status mati tersimpan")
	var bad := saved.duplicate(true)
	bad["combat"]["hp"] = {"spawn_palsu": 3}
	var s3 := _session()
	s3.combat.exp_total = 9
	check(not s3.from_dict(bad), "data combat rusak ditolak")
	check_eq(s3.combat.exp_total, 9, "rollback utuh")
