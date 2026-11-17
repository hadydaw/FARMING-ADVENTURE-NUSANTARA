extends TestCase

func _session(clock: GameClock) -> FarmingSession:
	var ids: Array = []
	for r in DataRegistry.rows("farm_plots"):
		ids.append(str(r["id"]))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), ids,
		DataRegistry.get_row("farm_config", "default"), DataRegistry.rows("weather_types"),
		DataRegistry.rows("weather_chances"), 5, DataRegistry.rows("vitality_meters"),
		DataRegistry.get_row("rest_config", "default"))


func run() -> void:
	# Data
	for m in DataRegistry.rows("vitality_meters"):
		check(bool(m.get("provisional", false)), "meter sementara: %s" % m["id"])
		check(tr(str(m["name_key"])) != str(m["name_key"]), "meter punya terjemahan: %s" % m["id"])
	var rc: Dictionary = DataRegistry.get_row("rest_config", "default")
	check(bool(rc.get("provisional", false)), "konfigurasi istirahat sementara")

	# Vitality
	var v := Vitality.new([{"id": "stamina", "max": 10, "start": 8}, {"id": "health", "max": 50, "start": 50}])
	check_eq(v.value("stamina"), 8, "nilai awal")
	check_eq(v.change("stamina", 5), 2, "naik dibatasi max")
	check_eq(v.value("stamina"), 10, "tidak melebihi max")
	check_eq(v.change("stamina", -99), -10, "turun dibatasi 0")
	check_eq(v.value("stamina"), 0, "tidak di bawah 0")
	check_eq(v.change("tak_ada", 5), 0, "meter tak dikenal diabaikan")
	check(not v.spend("stamina", 1), "tak cukup: ditolak")
	v.restore_full("stamina")
	check(v.spend("stamina", 4), "keluarkan 4")
	check_eq(v.value("stamina"), 6, "sisa 6")
	check(not v.spend("stamina", -1), "jumlah negatif ditolak")
	var snap := v.to_dict()
	var v2 := Vitality.new([{"id": "stamina", "max": 10, "start": 0}, {"id": "health", "max": 50, "start": 0}])
	check(v2.from_dict(snap) and v2.value("stamina") == 6 and v2.value("health") == 50, "muat vitalitas")
	var bad := snap.duplicate(true)
	bad["values"]["stamina"] = 99
	check(not v2.from_dict(bad), "nilai di luar rentang ditolak")
	check_eq(v2.value("stamina"), 6, "status utuh setelah gagal")
	check(not v2.from_dict({"v": 1, "values": {"stamina": 1}}), "meter kurang ditolak")

	# Stamina pada aksi pertanian
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s := _session(clock)
	check_eq(s.vitality.value("stamina"), 20, "stamina awal penuh")
	s.act_on("plot_01")  # cangkul (2)
	check_eq(s.vitality.value("stamina"), 18, "cangkul memakai 2 stamina")
	s.vitality.change("stamina", -s.vitality.value("stamina"))
	check_eq(str(s.act_on("plot_01")["reason"]), "too_tired", "tanpa stamina ditolak")
	check(not s.grid.plot("plot_01").has_crop(), "aksi tidak terjadi saat lelah")
	check_eq(s.inventory.count("seed_test_a"), 6, "benih tidak terpakai saat lelah")

	# Tidur: maju bertahap ke jam bangun, pulih, ganti hari
	var days: Array[int] = []
	clock.day_changed.connect(func(d): days.append(d))
	check_eq(clock.hour(), 6, "mulai pukul 06")
	check(s.sleep.begin(), "mulai tidur")
	check(not s.sleep.begin(), "tidak bisa mulai dua kali")
	check(clock.is_paused(), "jam nyata dijeda selama tidur")
	check_eq(str(s.act_on("plot_01")["reason"]), "sleeping", "aksi ditolak saat tidur")
	var steps := 0
	while not s.sleep.step(120):
		steps += 1
		check(steps < 50, "tidur selesai dalam langkah wajar")
		if steps >= 50:
			break
	check(steps > 3, "pemrosesan dibagi beberapa langkah (%d)" % steps)
	check_eq(clock.hour(), 6, "bangun pukul jam bangun")
	check_eq(clock.day_index(), 1, "hari berganti")
	check_eq(days, [1], "day_changed tepat sekali")
	check(not clock.is_paused(), "jam berjalan lagi")
	check(not s.sleep.is_sleeping(), "tidak lagi tidur")
	check_eq(s.vitality.value("stamina"), 20, "stamina pulih setelah tidur")

	# Tidur dini hari (sebelum jam bangun) tidak melompat satu hari penuh
	var c2 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	c2.add_minutes(c2.minutes_per_day() - 5 * 60)  # 05:00 hari 1 -> sebenarnya 01:00? jam awal 06 + 19h = 01:00
	var s2 := _session(c2)
	var day_before := c2.day_index()
	var h := c2.hour()
	check(h < 6, "kini dini hari (%d)" % h)
	s2.sleep.begin()
	while not s2.sleep.step(60):
		pass
	check_eq(c2.day_index(), day_before, "tidur dini hari tetap di hari yang sama")
	check_eq(c2.hour(), 6, "bangun pukul 06")

	# Total menit tidak pernah mundur dan tidak bergantung langkah
	var c3 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s3 := _session(c3)
	var c4 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s4 := _session(c4)
	s3.sleep.begin(); s4.sleep.begin()
	while not s3.sleep.step(7):
		pass
	while not s4.sleep.step(500):
		pass
	check_eq(c3.total_minutes, c4.total_minutes, "hasil sama berapa pun ukuran langkah")

	# Pertumbuhan tanaman terjadi saat tidur (pergantian hari diproses)
	var c5 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s5 := _session(c5)
	s5.world_seed = 0
	for sd in 300:
		s5.world_seed = sd
		if not s5.is_raining_today():
			break
	s5.act_on("plot_01"); s5.act_on("plot_01"); s5.act_on("plot_01")  # cangkul, tanam, siram
	s5.sleep.begin()
	while not s5.sleep.step():
		pass
	check_eq(s5.grid.plot("plot_01").stage, 1, "tanaman tumbuh setelah tidur")

	# Simpan/muat membawa vitalitas
	s5.vitality.change("health", -30)
	var d := s5.to_dict()
	var s6 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	check(s6.from_dict(d), "muat sesi dengan vitalitas")
	check_eq(s6.vitality.value("health"), 70, "HP dipulihkan")
	var d_bad := d.duplicate(true)
	d_bad["vitality"]["values"]["health"] = 5000
	var before := JSON.stringify(s6.to_dict())
	check(not s6.from_dict(d_bad), "vitalitas rusak menolak seluruh muat")
	check_eq(JSON.stringify(s6.to_dict()), before, "status utuh setelah muat gagal")
