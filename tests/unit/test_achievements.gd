extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"quests": DataRegistry.rows("quests"), "guild_config": DataRegistry.get_row("guild_config", "default"), "dungeons": DataRegistry.rows("dungeons"),
		"achievements": DataRegistry.rows("achievements")})


func run() -> void:
	for a in DataRegistry.rows("achievements"):
		check(bool(a.get("provisional", false)) and (str(a["kind"]) == "achievement" or str(a["kind"]) == "hint"), "baris valid: %s" % a["id"])
		check(tr(str(a["name_key"])) != str(a["name_key"]), "terjemahan %s" % a["id"])
	var s := _session()
	var first := s.check_milestones()
	var ids: Array = first.map(func(r): return str(r["id"]))
	check(ids.has("hint_start") and ids.size() == 1, "hanya petunjuk awal di awal")
	check(s.check_milestones().is_empty(), "tidak diumumkan dua kali")
	s.combat.kills = 1
	s.economy.money = 600
	var ids2: Array = s.check_milestones().map(func(r): return str(r["id"]))
	check(ids2.has("ach_first_blood") and ids2.has("hint_first_kill") and ids2.has("ach_rich"), "terbuka sesuai statistik")
	check(not ids2.has("ach_hunter"), "ambang belum tercapai")
	check_eq(s.achievements.unlocked_count("achievement"), 2, "hitung pencapaian")
	# simpan/muat
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat")
	check(s2.achievements.is_unlocked("ach_rich"), "tersimpan")
	check(s2.check_milestones().is_empty(), "tidak diumumkan ulang setelah muat")
	var bad := saved.duplicate(true)
	bad["achievements"]["unlocked"] = ["palsu"]
	var s3 := _session()
	s3.check_milestones()
	check(not s3.from_dict(bad), "rusak ditolak")
	check(s3.achievements.is_unlocked("hint_start"), "rollback")
	# save lama tanpa kunci: reset
	var old := saved.duplicate(true)
	old.erase("achievements")
	check(s3.from_dict(old), "save lama termuat")
	check(not s3.achievements.is_unlocked("hint_start"), "reset bila tak ada kunci")
	# level naik lewat EXP
	s3.combat.exp_total = 50
	var ids3: Array = s3.check_milestones().map(func(r): return str(r["id"]))
	check(ids3.has("ach_level_3"), "level 3")
