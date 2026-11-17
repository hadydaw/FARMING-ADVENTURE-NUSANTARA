extends TestCase

func _clock() -> GameClock:
	return GameClock.new(DataRegistry.get_row("time_config", "default"))


func _inv() -> Inventory:
	var stack := {}
	for it in DataRegistry.rows("items"):
		stack[str(it["id"])] = int(it["stack_max"])
	return Inventory.new(24, func(id): return stack.get(id, 0))


func _combat() -> CombatState:
	return CombatState.new(DataRegistry.rows("monsters"), DataRegistry.rows("monster_spawns"), DataRegistry.get_row("combat_config", "default"))


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	var tc: Dictionary = DataRegistry.get_row("time_config", "default")
	for f in DataRegistry.rows("festivals"):
		check(bool(f.get("provisional", false)) and items.has(str(f["gift"]["item"])), "festival valid: %s" % f["id"])
		check((tc["seasons"] as Array).has(str(f["season"])) and int(f["day"]) >= 1 and int(f["day"]) <= int(tc["days_per_season"]), "tanggal valid")
		check(tr(str(f["name_key"])) != str(f["name_key"]), "terjemahan")
	var cal := FestivalCalendar.new(DataRegistry.rows("festivals"))
	check(cal.event_on("season_1", 14).get("id", "") == "festival_test_1", "festival ditemukan")
	check(cal.event_on("season_1", 15).is_empty(), "hari biasa kosong")
	var clock := _clock()
	var inv := _inv()
	var cb := _combat()
	check(not bool(cal.claim_today(clock, inv, cb)["ok"]), "hari 1 tidak ada festival")
	var nx := cal.next_event(clock)
	check_eq(int(nx["days_ahead"]), 13, "festival berikutnya 13 hari lagi")
	# Maju ke hari festival
	clock.total_minutes = 13 * clock.minutes_per_day() + 6 * 60
	check_eq(clock.day_of_season(), 14, "hari ke-14")
	var r := cal.claim_today(clock, inv, cb)
	check(bool(r["ok"]) and bool(r["gift_given"]), "klaim berhasil")
	check_eq(inv.count("meal_test_a"), 2, "hadiah masuk")
	check_eq(cb.exp_total, 5, "EXP festival")
	check(not bool(cal.claim_today(clock, inv, cb)["ok"]), "tidak bisa dobel di hari sama")
	# Tahun berikutnya bisa lagi
	clock.total_minutes += clock.days_per_year() * clock.minutes_per_day()
	check(bool(cal.claim_today(clock, inv, cb)["ok"]), "tahun berikutnya klaim lagi")
	check_eq(inv.count("meal_test_a"), 4, "hadiah tahun kedua")
	# Tas penuh: terlewat, tercatat
	var cal2 := FestivalCalendar.new(DataRegistry.rows("festivals"))
	var full := _inv()
	for i in 24:
		full.add("tool_hoe", 1) if full.can_add("tool_hoe", 1) else null
	for i in 40:
		full.add("seed_test_a", 20)
		full.add("seed_test_b", 20)
		full.add("produce_test_a", 20)
		full.add("produce_test_b", 20)
		full.add("herb_test", 99)
		full.add("material_stone_test", 99)
	clock.total_minutes = 13 * clock.minutes_per_day() + 6 * 60
	var rf := cal2.claim_today(clock, full, _combat())
	check(bool(rf["ok"]), "klaim tercatat")
	check(not bool(rf["gift_given"]) or full.count("meal_test_a") > 0, "hadiah konsisten dengan ruang tas")
	check(not bool(cal2.claim_today(clock, full, _combat())["ok"]), "tidak dicoba ulang")
	# Simpan/muat
	var saved := cal.to_dict()
	var cal3 := FestivalCalendar.new(DataRegistry.rows("festivals"))
	check(cal3.from_dict(saved), "muat")
	check(not bool(cal3.claim_today(clock, _inv(), _combat())["ok"]), "klaim tahun ini tersimpan setelah muat")
	check(not cal3.from_dict({"v": 1, "claimed": ["palsu:1"]}), "kunci tak dikenal ditolak")
	check(not cal3.from_dict({"v": 1, "claimed": ["festival_test_1:x"]}), "tahun tak valid ditolak")
