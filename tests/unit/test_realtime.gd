extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices")})


func run() -> void:
	var cfg: Dictionary = DataRegistry.get_row("combat_config", "default")
	for k in ["player_cooldown", "monster_interval", "aggro_range", "attack_range", "monster_speed", "leash"]:
		check(cfg.has(k) and float(cfg[k]) > 0.0, "config waktu-nyata: %s" % k)
	check(float(cfg["attack_range"]) < float(cfg["aggro_range"]) and float(cfg["aggro_range"]) < float(cfg["leash"]), "jarak: serang < kejar < batas")

	# Keputusan monster murni
	var rt := RealtimeCombat.new(cfg)
	check_eq(rt.monster_decision("m", 20.0, 0.1), "idle", "jauh = diam")
	check_eq(rt.monster_decision("m", 5.0, 0.1), "chase", "dalam jarak kejar = mengejar")
	check_eq(rt.monster_decision("m", 1.0, 0.1), "wait", "dalam jangkauan tapi jeda belum habis")
	var attacked := false
	for i in 20:
		if rt.monster_decision("m", 1.0, 0.1) == "attack":
			attacked = true
			break
	check(attacked, "akhirnya menyerang setelah jeda")
	check_eq(rt.monster_decision("m", 1.0, 0.1), "wait", "jeda diulang setelah menyerang")
	check_eq(rt.monster_decision("m", 30.0, 0.1), "idle", "keluar jangkauan: reset")
	# Jeda serang pemain
	check(rt.can_strike(), "awal siap")
	rt.mark_strike()
	check(not rt.can_strike(), "jeda setelah serang")
	rt.tick(0.3)
	check(not rt.can_strike(), "belum habis")
	rt.tick(0.3)
	check(rt.can_strike(), "jeda habis")

	# Sesi: serang tanpa balasan instan; jeda menolak
	var s := _session()
	var hp0 := s.vitality.value("health")
	var r1 := s.strike_monster("ms_forest_1")
	check(bool(r1["ok"]) and int(r1["taken"]) == 0, "serang tanpa balasan instan")
	check_eq(s.vitality.value("health"), hp0, "HP pemain tidak berkurang saat serang")
	check_eq(str(s.strike_monster("ms_forest_1")["reason"]), "cooldown", "terlalu cepat ditolak")
	s.realtime.tick(1.0)
	check(bool(s.strike_monster("ms_forest_1")["ok"]), "boleh lagi setelah jeda")
	# Balasan monster waktu-nyata
	var back := s.monster_retaliate("ms_forest_1")
	check_eq(int(back["taken"]), 3, "balasan monster = serangan monster")
	# Pingsan lewat balasan
	s.economy.money = 100
	s.vitality.change("health", -(s.vitality.value("health") - 2))
	var fb := s.monster_retaliate("ms_forest_3")
	check(bool(fb["fainted"]), "pingsan oleh balasan")
	check_eq(s.economy.money, 90, "uang berkurang")
	check_eq(str(s.monster_retaliate("tidak_ada").get("taken", -1)), "0", "spawn tak dikenal aman")
	# Monster pulih
	s.combat.heal_spawn("ms_forest_1")
	check_eq(s.combat.hp_of("ms_forest_1", 0), 12, "monster pulih penuh")

	# Dunia: monster mengejar, menyerang, dan kembali ke asal
	GameTime.new_game()
	await SceneManager.go("world_start", true, false)
	await wait_frames(3)
	var w: WorldStart = tree.current_scene
	w._place_player("region_forest", -6.0, -1.0)
	var node: Node3D = w.sites.monster_nodes["ms_forest_1"]
	var home: Vector3 = node.get_meta("home")
	var d0 := node.global_position.distance_to(w.player.global_position)
	var hp_start := w.farming.vitality.value("health")
	for i in 80:
		w.sites.update_monsters(0.1)
	check(node.global_position.distance_to(w.player.global_position) < d0, "monster mendekat")
	check(w.farming.vitality.value("health") < hp_start, "monster menyerang pemain")
	# Pemain kabur jauh: monster pulang
	w._place_player("region_village", 0.0, 4.0)
	for i in 400:
		w.sites.update_monsters(0.1)
	check(node.global_position.distance_to(home) < 0.5, "monster kembali ke tempat asal")
	check_eq(w.farming.combat.hp_of("ms_forest_1", 0), 12, "monster pulih setelah pulang")
	# Menu terbuka = monster berhenti
	w._place_player("region_forest", -6.0, -1.0)
	w.hud.show_menu("x", [])
	var p0 := node.global_position
	var hp1 := w.farming.vitality.value("health")
	for i in 50:
		w.sites.update_monsters(0.1)
	check(node.global_position.is_equal_approx(p0) and w.farming.vitality.value("health") == hp1, "menu terbuka: monster diam")
	w.hud.hide_menu()
	await SceneManager.go("main_menu", false, false)
	GameTime.new_game()
