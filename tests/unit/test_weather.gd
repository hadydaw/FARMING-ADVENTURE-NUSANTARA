extends TestCase

func _session(clock: GameClock, seed_value: int) -> FarmingSession:
	var ids: Array = []
	for r in DataRegistry.rows("farm_plots"):
		ids.append(str(r["id"]))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), ids,
		DataRegistry.get_row("farm_config", "default"), DataRegistry.rows("weather_types"),
		DataRegistry.rows("weather_chances"), seed_value)


func run() -> void:
	# Data
	var types := {}
	for w in DataRegistry.rows("weather_types"):
		types[str(w["id"])] = w
		check(bool(w.get("provisional", false)), "cuaca ditandai sementara: %s" % w["id"])
		check(tr(str(w["name_key"])) != str(w["name_key"]), "cuaca punya terjemahan: %s" % w["id"])
	var chances := {}
	for c in DataRegistry.rows("weather_chances"):
		chances[str(c["id"])] = c
		for k in c["weights"]:
			check(types.has(k), "bobot merujuk cuaca ada: %s/%s" % [c["id"], k])
	for s_id in DataRegistry.get_row("time_config", "default")["seasons"]:
		check(chances.has(str(s_id)), "peluang ada untuk musim %s" % s_id)

	# Determinisme
	var w := {"clear": 70, "rain": 30}
	check_eq(WeatherModel.pick(1, 5, w), WeatherModel.pick(1, 5, w), "hari sama, seed sama -> cuaca sama")
	var diff := 0
	for d in 200:
		if WeatherModel.pick(1, d, w) != WeatherModel.pick(2, d, w):
			diff += 1
	check(diff > 20, "seed berbeda memberi urutan berbeda (%d beda)" % diff)
	var rain := 0
	for d in 2000:
		if WeatherModel.pick(7, d, w) == "rain":
			rain += 1
	check(rain > 500 and rain < 700, "peluang hujan mendekati 30%% (%d/2000)" % rain)
	check_eq(WeatherModel.pick(1, 1, {}), "", "tanpa bobot -> kosong")
	check_eq(WeatherModel.pick(1, 1, {"a": 0, "b": 0}), "", "bobot nol -> kosong")
	check_eq(WeatherModel.pick(1, 1, {"only": 5}), "only", "satu pilihan selalu terpilih")
	check_eq(WeatherModel.weather_for(1, 1, "musim_tidak_ada", chances), "", "musim tak dikenal -> kosong")
	var before := JSON.stringify([WeatherModel.pick(3, 10, w), WeatherModel.pick(3, 11, w)])
	check_eq(JSON.stringify([WeatherModel.pick(3, 10, w), WeatherModel.pick(3, 11, w)]), before, "tidak bergantung urutan pemanggilan")

	# Musim per hari
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	check_eq(clock.season_id_for_day(0), "season_1", "hari 0 musim 1")
	check_eq(clock.season_id_for_day(28), "season_2", "hari 28 musim 2")
	check_eq(clock.season_id_for_day(112), "season_1", "setelah 4 musim kembali ke musim 1")

	# Hujan menyiram tanaman; hari cerah tanpa siram tidak tumbuh
	var seed_rain := -1
	var seed_clear := -1
	for sd in 400:
		var wd := WeatherModel.weather_for(sd, 0, "season_1", chances)
		if wd == "rain" and seed_rain < 0:
			seed_rain = sd
		if wd == "clear" and seed_clear < 0:
			seed_clear = sd
	check(seed_rain >= 0 and seed_clear >= 0, "ada seed uji hujan dan cerah di hari 0")

	var c1 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s1 := _session(c1, seed_rain)
	check(s1.is_raining_today(), "hari 0 hujan")
	s1.act_on("plot_01"); s1.act_on("plot_01")  # cangkul, tanam
	check_eq(str(s1.act_on("plot_01")["reason"]), "raining", "saat hujan tidak perlu menyiram")
	c1.add_minutes(c1.minutes_per_day())
	check_eq(s1.grid.plot("plot_01").stage, 1, "hujan memajukan tumbuh tanpa siram")

	var c2 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s2 := _session(c2, seed_clear)
	check(not s2.is_raining_today(), "hari 0 cerah")
	s2.act_on("plot_01"); s2.act_on("plot_01")
	c2.add_minutes(c2.minutes_per_day())
	check_eq(s2.grid.plot("plot_01").stage, 0, "cerah tanpa siram: tidak tumbuh")

	# Save/load menjaga world_seed -> cuaca sama
	var s3 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")), 0)
	check(s3.from_dict(s2.to_dict()), "muat dengan world_seed")
	check_eq(s3.world_seed, seed_clear, "world_seed dipulihkan")
	for d in 30:
		check_eq(s3.weather_on_day(d), s2.weather_on_day(d), "cuaca sama setelah muat (hari %d)" % d) if d < 3 else null
	var same := true
	for d in 60:
		if s3.weather_on_day(d) != s2.weather_on_day(d):
			same = false
	check(same, "urutan cuaca 60 hari identik setelah muat")
