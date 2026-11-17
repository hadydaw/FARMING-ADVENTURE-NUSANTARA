extends TestCase

func _cfg() -> Dictionary:
	return {
		"game_minutes_per_real_second": 1.0, "minutes_per_hour": 60, "hours_per_day": 24,
		"days_per_season": 3, "seasons": ["a", "b"], "start_hour": 6, "max_step_seconds": 1.0,
		"phases": [{"id": "night", "start_hour": 0}, {"id": "day", "start_hour": 6}, {"id": "night", "start_hour": 20}],
	}


func run() -> void:
	var c := GameClock.new(_cfg())
	check_eq(c.hour(), 6, "jam awal dari start_hour")
	check_eq(c.minute(), 0, "menit awal 0")
	check_eq(c.day_index(), 0, "hari awal 0")
	check_eq(c.day_of_season(), 1, "hari musim 1-based")
	check_eq(c.year(), 1, "tahun 1-based")
	check_eq(c.phase_id(), "day", "fase pukul 06 = day")
	check_eq(c.time_text(), "06:00", "format waktu")
	check(GameClock.validate_config(_cfg()).is_empty(), "konfigurasi uji valid")

	# Kemajuan waktu dan akumulasi pecahan
	check_eq(c.advance(0.5), 0, "0,5 detik belum menambah menit")
	check_eq(c.advance(0.5), 1, "akumulasi mencapai 1 menit")
	check_eq(c.minute(), 1, "menit naik")
	check_eq(c.advance(-5.0), 0, "delta negatif diabaikan (waktu tidak mundur)")
	check_eq(c.minute(), 1, "waktu tidak mundur")
	check_eq(c.advance(100.0), 1, "langkah besar dibatasi max_step_seconds")

	# Sinyal jam/fase/hari/musim
	var d := GameClock.new(_cfg())
	var hours: Array[int] = []
	var days: Array[int] = []
	var phases: Array[String] = []
	var seasons: Array[String] = []
	d.hour_changed.connect(func(h): hours.append(h))
	d.day_changed.connect(func(x): days.append(x))
	d.phase_changed.connect(func(p): phases.append(p))
	d.season_changed.connect(func(s): seasons.append(s))
	d.add_minutes(14 * 60)          # 06:00 -> 20:00
	check_eq(phases, ["night"], "fase berganti ke night pukul 20")
	check_eq(hours.size(), 14, "14 pergantian jam")
	d.add_minutes(4 * 60)           # -> 00:00 hari 1
	check_eq(days, [1], "hari berganti tengah malam")
	check_eq(d.day_of_season(), 2, "hari musim 2")
	d.add_minutes(2 * 24 * 60)      # hari 3 -> musim baru
	check_eq(d.season_id(), "b", "musim berganti setelah days_per_season")
	check_eq(seasons, ["b"], "sinyal musim terkirim sekali")
	d.add_minutes(3 * 24 * 60)      # hari 6 -> tahun 2
	check_eq(d.year(), 2, "tahun bertambah setelah semua musim")
	check_eq(d.season_id(), "a", "musim kembali ke awal")
	d.add_minutes(-10)
	check_eq(d.year(), 2, "add_minutes negatif ditolak")

	# Jeda dengan beberapa alasan
	var p := GameClock.new(_cfg())
	var states: Array[bool] = []
	p.paused_changed.connect(func(v): states.append(v))
	p.pause("menu")
	p.pause("dialog")
	check_eq(p.advance(1.0), 0, "waktu berhenti saat dijeda")
	p.resume("menu")
	check(p.is_paused(), "masih dijeda karena alasan lain")
	p.resume("dialog")
	check(not p.is_paused(), "lanjut setelah semua alasan dicabut")
	check_eq(states, [true, false], "sinyal jeda hanya saat berubah status")
	check_eq(p.advance(1.0), 1, "waktu jalan lagi")

	# Simpan/muat
	var s := GameClock.new(_cfg())
	s.add_minutes(12345)
	var saved := s.to_dict()
	var r := GameClock.new(_cfg())
	check(r.from_dict(JSON.parse_string(JSON.stringify(saved))), "muat dari JSON")
	check_eq(r.total_minutes, s.total_minutes, "total menit pulih setelah JSON")
	check(not r.from_dict({"v": 99, "total_minutes": 5}), "versi tak dikenal ditolak")
	check(not r.from_dict({"v": 1, "total_minutes": -3}), "waktu negatif ditolak")
	check(not r.from_dict({"v": 1, "total_minutes": "x"}), "tipe salah ditolak")
	check(not r.from_dict({"v": 1, "total_minutes": 1.5}), "pecahan ditolak")
	check_eq(r.total_minutes, s.total_minutes, "data buruk tidak mengubah keadaan")

	# Seed harian deterministik dan beragam
	check_eq(GameClock.daily_seed(42, 7), GameClock.daily_seed(42, 7), "seed harian deterministik")
	check(GameClock.daily_seed(42, 7) != GameClock.daily_seed(42, 8), "hari beda, seed beda")
	check(GameClock.daily_seed(42, 7) != GameClock.daily_seed(43, 7), "dunia beda, seed beda")
	check_eq(GameClock.daily_seed(1, 1), GameClock.daily_seed(1, 1), "seed stabil")

	# Validasi konfigurasi
	var bad := _cfg()
	bad["days_per_season"] = 0
	check(not GameClock.validate_config(bad).is_empty(), "days_per_season 0 ditolak")
	bad = _cfg()
	bad["phases"] = [{"id": "x", "start_hour": 3}]
	check(not GameClock.validate_config(bad).is_empty(), "fase pertama harus pukul 0")
	bad = _cfg()
	bad["phases"] = [{"id": "x", "start_hour": 0}, {"id": "y", "start_hour": 0}]
	check(not GameClock.validate_config(bad).is_empty(), "start_hour harus naik ketat")
	bad = _cfg()
	bad["seasons"] = []
	check(not GameClock.validate_config(bad).is_empty(), "seasons kosong ditolak")

	# Data nyata + autoload GameTime
	var reg: Node = tree.root.get_node("DataRegistry")
	var real: Dictionary = reg.get_row("time_config", "default")
	check(not real.is_empty(), "time_config.default ada di registri")
	check(GameClock.validate_config(real).is_empty(), "time_config.default valid")
	check_eq(bool(real.get("provisional", false)), true, "nilai waktu ditandai sementara")
	var gt: Node = tree.root.get_node("GameTime")
	check(gt.clock != null, "autoload GameTime punya jam")
	var seen: Array[int] = []
	var cb := func(m): seen.append(m)
	tree.root.get_node("Events").time_changed.connect(cb)
	gt.clock.add_minutes(2)
	tree.root.get_node("Events").time_changed.disconnect(cb)
	check_eq(seen.size(), 2, "GameTime meneruskan waktu ke Events")
	gt.new_game()
	check_eq(gt.clock.hour(), int(real["start_hour"]), "new_game mengatur ulang waktu")
