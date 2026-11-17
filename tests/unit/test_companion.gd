extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"companions": DataRegistry.rows("companions"), "dungeons": DataRegistry.rows("dungeons")})


func run() -> void:
	for c in DataRegistry.rows("companions"):
		check(bool(c.get("provisional", false)) and int(c["cost"]) > 0 and int(c["attack"]) >= 0, "companion valid: %s" % c["id"])
		check(tr(str(c["name_key"])) != str(c["name_key"]), "terjemahan")
	var s := _session()
	var base_atk := s.combat.player_attack(s.inventory, s.item_defs)
	check_eq(str(s.companion_toggle("companion_test_a")["reason"]), "not_owned", "belum direkrut")
	check_eq(str(s.companion_recruit("palsu")["reason"]), "unknown", "tak dikenal")
	s.economy.money = 50
	check_eq(str(s.companion_recruit("companion_test_a")["reason"]), "no_money", "uang kurang")
	check_eq(s.economy.money, 50, "uang tetap")
	s.economy.money = 500
	check(bool(s.companion_recruit("companion_test_a")["ok"]), "rekrut")
	check_eq(s.economy.money, 380, "biaya dibayar")
	check_eq(str(s.companion_recruit("companion_test_a")["reason"]), "owned", "tidak dobel")
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), base_atk, "belum aktif: tanpa bonus")
	check(bool(s.companion_toggle("companion_test_a")["ok"]), "aktifkan")
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), base_atk + 2, "bonus serangan")
	check_eq(s.combat.player_defense(), 1, "bonus penahan")
	# Penahan mengurangi serangan balik: slime atk 3 -> 2
	var r := s.attack_monster("ms_forest_1")
	check_eq(int(r["taken"]), 2, "serangan balik dikurangi penahan")
	# Ganti dan istirahatkan
	s.economy.money = 500
	s.companion_recruit("companion_test_b")
	s.companion_toggle("companion_test_b")
	check_eq(s.companions.active_id, "companion_test_b", "diganti")
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), base_atk + 4, "bonus teman B")
	s.companion_toggle("companion_test_b")
	check_eq(s.combat.player_attack(s.inventory, s.item_defs), base_atk, "istirahat: bonus hilang")
	# Simpan/muat memulihkan teman aktif dan bonusnya
	s.companion_toggle("companion_test_a")
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat")
	check_eq(s2.companions.active_id, "companion_test_a", "aktif dipulihkan")
	check_eq(s2.combat.player_attack(s2.inventory, s2.item_defs), base_atk + 2, "bonus dipulihkan setelah muat")
	# Save tanpa kunci companion: direset
	var plain := _session().to_dict()
	plain.erase("companions")
	check(s.from_dict(plain), "muat save lama")
	check_eq(s.companions.active_id, "", "companion direset")
	check_eq(s.combat.bonus_attack, 0, "bonus direset")
	# Rusak: aktif tanpa dimiliki
	var s3 := _session()
	s3.economy.money = 500
	s3.companion_recruit("companion_test_a")
	s3.companion_toggle("companion_test_a")
	var before := JSON.stringify(s3.to_dict())
	var bad := saved.duplicate(true)
	bad["companions"] = {"v": 1, "owned": [], "active": "companion_test_b"}
	check(not s3.from_dict(bad), "aktif tanpa dimiliki ditolak")
	check_eq(JSON.stringify(s3.to_dict()), before, "rollback utuh")
	check_eq(s3.combat.bonus_attack, 2, "bonus tetap")
	# Dungeon memakai penahan juga
	var d := _session()
	d.economy.money = 500
	d.companion_recruit("companion_test_b")
	d.companion_toggle("companion_test_b")
	d.dungeon_start("dungeon_test")
	var dr := d.dungeon_attack()
	check(bool(dr["ok"]) and int(dr["taken"]) >= 0, "dungeon berjalan dengan companion")
