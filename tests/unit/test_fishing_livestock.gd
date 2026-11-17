extends TestCase

func _session(clock: GameClock, seed_value: int = 11) -> FarmingSession:
	var ids: Array = []
	for r in DataRegistry.rows("farm_plots"):
		ids.append(str(r["id"]))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), ids,
		DataRegistry.get_row("farm_config", "default"), DataRegistry.rows("weather_types"),
		DataRegistry.rows("weather_chances"), seed_value, DataRegistry.rows("vitality_meters"),
		DataRegistry.get_row("rest_config", "default"),
		{"fish_species": DataRegistry.rows("fish_species"), "fishing_config": DataRegistry.get_row("fishing_config", "default"),
		"animals": DataRegistry.rows("animals"), "livestock_config": DataRegistry.get_row("livestock_config", "default")})


func run() -> void:
	# --- Data ---
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = it
	for f in DataRegistry.rows("fish_species"):
		check(bool(f.get("provisional", false)) and items.has(str(f["item"])), "ikan sementara dan item ada: %s" % f["id"])
	for a in DataRegistry.rows("animals"):
		check(bool(a.get("provisional", false)), "hewan sementara: %s" % a["id"])
		check(items.has(str(a["feed_item"])) and items.has(str(a["product_item"])), "item hewan ada: %s" % a["id"])
		check(tr(str(a["name_key"])) != str(a["name_key"]), "nama hewan diterjemahkan")
	var missing := 0
	for k in items:
		if tr(str(items[k]["name_key"])) == str(items[k]["name_key"]):
			missing += 1
	check_eq(missing, 0, "semua item punya terjemahan")

	# --- FishingModel ---
	var fish: Array = DataRegistry.rows("fish_species")
	var cfg: Dictionary = DataRegistry.get_row("fishing_config", "default")
	var av := FishingModel.available(fish, "pond", "season_1", "clear", 9)
	check_eq(av.size(), 2, "pagi musim 1 cerah: ikan a dan b")
	check_eq(FishingModel.available(fish, "pond", "season_3", "clear", 9).size(), 1, "musim 3 cerah: hanya a")
	check_eq(FishingModel.available(fish, "pond", "season_1", "rain", 14).size(), 2, "hujan siang: a dan c")
	check_eq(FishingModel.available(fish, "laut", "season_1", "clear", 9).size(), 0, "habitat lain kosong")
	check(FishingModel.plan_cast(1, 0, 0, [], false, cfg).is_empty(), "tanpa kandidat -> kosong")
	var p1 := FishingModel.plan_cast(5, 3, 2, av, false, cfg)
	var p2 := FishingModel.plan_cast(5, 3, 2, av, false, cfg)
	check_eq(JSON.stringify(p1), JSON.stringify(p2), "rencana lemparan deterministik")
	check(float(p1["wait"]) >= 2.0 and float(p1["wait"]) <= 5.0, "waktu tunggu dalam rentang")
	var rare_plain := 0
	var rare_bait := 0
	var av_rain := FishingModel.available(fish, "pond", "season_1", "rain", 14)
	for n in 600:
		if FishingModel.plan_cast(9, n, 0, av_rain, false, cfg)["species_id"] == "fish_c":
			rare_plain += 1
		if FishingModel.plan_cast(9, n, 0, av_rain, true, cfg)["species_id"] == "fish_c":
			rare_bait += 1
	check(rare_bait > rare_plain * 1.5, "umpan meningkatkan peluang ikan langka (%d vs %d)" % [rare_bait, rare_plain])
	var counts := {}
	for n in 600:
		var sid: String = FishingModel.plan_cast(9, 0, n, av, false, cfg)["species_id"]
		counts[sid] = int(counts.get(sid, 0)) + 1
	check(int(counts["fish_a"]) > int(counts["fish_b"]), "ikan umum lebih sering (%s)" % str(counts))

	# --- FishingCast ---
	var c := FishingCast.new({"species_id": "fish_a", "wait": 2.0, "window": 1.0})
	c.advance(1.0)
	check_eq(c.state, FishingCast.WAITING, "masih menunggu")
	c.advance(1.0)
	check_eq(c.state, FishingCast.BITE, "gigitan setelah waktu tunggu")
	check_eq(c.reel(), FishingCast.CAUGHT, "ditarik saat gigitan = dapat")
	c.advance(10.0)
	check_eq(c.state, FishingCast.CAUGHT, "status akhir tidak berubah")
	var c2 := FishingCast.new({"species_id": "fish_a", "wait": 2.0, "window": 1.0})
	check_eq(c2.reel(), FishingCast.ESCAPED, "terlalu cepat = lepas")
	check_eq(c2.failure, "early", "alasan terlalu cepat")
	var c3 := FishingCast.new({"species_id": "fish_a", "wait": 2.0, "window": 1.0})
	c3.advance(2.5)
	c3.advance(1.0)
	check(c3.state == FishingCast.ESCAPED and c3.failure == "late", "lewat jendela = lepas")
	c3.advance(-1.0)

	# --- Sesi: memancing ---
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s := _session(clock)
	var r := s.begin_fishing("spot_pond")
	check(bool(r["ok"]), "mulai memancing")
	check_eq(s.vitality.value("stamina"), 18, "stamina terpakai")
	check_eq(s.inventory.count("bait_test"), 4, "umpan terpakai")
	var cs: FishingCast = r["cast"]
	cs.advance(10.0)
	cs.advance(0.0)
	var cs2 := FishingCast.new({"species_id": cs.species_id, "wait": 0.0, "window": 5.0})
	cs2.advance(0.1)
	cs2.reel()
	var got := s.finish_fishing(cs2)
	check(got != "" and s.inventory.has(got), "ikan masuk inventory")
	check_eq(s.finish_fishing(cs), "", "lemparan gagal tidak memberi ikan")
	check_eq(str(s.begin_fishing("tak_ada")["reason"]), "unknown_spot", "tempat tak dikenal")
	s.inventory.remove("tool_fishing_rod", 1)
	check_eq(str(s.begin_fishing("spot_pond")["reason"]), "need_rod", "butuh pancing")
	s.inventory.add("tool_fishing_rod", 1)
	s.vitality.change("stamina", -99)
	check_eq(str(s.begin_fishing("spot_pond")["reason"]), "too_tired", "butuh stamina")
	s.vitality.restore_full("stamina")
	# nomor lemparan naik -> hasil tidak sama terus; muat ulang tidak mengulang undian
	check_eq(s.fishing_casts_today, 1, "penghitung lemparan")
	var d := s.to_dict()
	var s2 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")), 0)
	check(s2.from_dict(d), "muat sesi dengan memancing+ternak")
	check_eq(s2.fishing_casts_today, 1, "penghitung lemparan dipulihkan")
	var p_a: Dictionary = s.begin_fishing("spot_pond")
	var p_b: Dictionary = s2.begin_fishing("spot_pond")
	check_eq((p_a["cast"] as FishingCast).species_id, (p_b["cast"] as FishingCast).species_id, "setelah muat, lemparan berikutnya sama (tanpa undian ulang)")
	clock.add_minutes(clock.minutes_per_day())
	check_eq(s.fishing_casts_today, 0, "penghitung reset tiap hari")
	# Tas penuh menolak lemparan
	var s3 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	s3.inventory.clear()
	s3.inventory.add("tool_fishing_rod", 1)
	for slot_i in 23:
		s3.inventory.add("tool_hoe", 1)
	check_eq(str(s3.begin_fishing("spot_pond")["reason"]), "inventory_full", "tas penuh menolak lemparan")

	# --- Hewan ---
	var def_a := DataRegistry.get_row("animals", "animal_a")
	var an := Animal.new("x", "animal_a")
	check(not an.is_mature(def_a), "hewan baru belum dewasa")
	check(an.feed() and not an.feed(), "beri pakan sekali per hari")
	an.advance_day(def_a, 3)
	check_eq(an.age_days, 1, "umur naik bila diberi pakan")
	check(not an.fed, "status pakan direset")
	an.advance_day(def_a, 3)
	check_eq(an.age_days, 1, "tanpa pakan tidak tumbuh")
	an.feed(); an.advance_day(def_a, 3)
	check(an.is_mature(def_a) and an.progress == 1, "dewasa di hari ke-2 diberi pakan, produksi mulai terhitung")
	an.feed(); an.advance_day(def_a, 3)
	an.feed(); an.advance_day(def_a, 3)
	check(an.is_ready(def_a), "siap panen setelah interval")
	check(an.collect(def_a) and an.progress == 0, "ambil hasil mengosongkan kemajuan")
	check(not an.collect(def_a), "tidak ada hasil lagi")
	var neg := Animal.new("n", "animal_a")
	neg.age_days = 5; neg.progress = 1
	for i in 3:
		neg.advance_day(def_a, 3)
	check_eq(neg.progress, 0, "terlantar melewati batas menghapus kemajuan")
	var saved := an.to_dict()
	var defs := {"animal_a": def_a}
	var an2 := Animal.new("x", "")
	check(an2.from_dict(saved, defs) and an2.age_days == an.age_days, "muat hewan")
	check(not Animal.new("x", "").from_dict({"v": 1, "id": "x", "species": "tak_ada", "age": 0, "fed": false, "progress": 0, "neglect": 0}, defs), "spesies tak dikenal ditolak")
	check(not Animal.new("x", "").from_dict({"v": 1, "id": "x", "species": "animal_a", "age": -1, "fed": false, "progress": 0, "neglect": 0}, defs), "umur negatif ditolak")

	# --- Sesi: peternakan ---
	var clock2 := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var t := _session(clock2)
	check_eq(str(t.animal_preview("pen_01")["action"]), "feed", "aksi: beri pakan")
	check(bool(t.animal_act("pen_01")["ok"]), "beri pakan")
	check_eq(t.inventory.count("feed_test"), 9, "pakan berkurang")
	check_eq(str(t.animal_act("pen_01")["reason"]), "not_hungry", "tidak bisa dua kali")
	check_eq(str(t.animal_act("tak_ada")["reason"]), "unknown_animal", "hewan tak dikenal")
	for i in 2:
		clock2.add_minutes(clock2.minutes_per_day())
		t.animal_act("pen_01")
	clock2.add_minutes(clock2.minutes_per_day())
	check_eq(str(t.animal_preview("pen_01")["action"]), "collect", "siap diambil")
	check(bool(t.animal_act("pen_01")["ok"]), "ambil hasil")
	check_eq(t.inventory.count("product_animal_test_a"), 1, "hasil ternak masuk inventory")
	t.inventory.clear()
	t.inventory.add("tool_hoe", 1)
	check_eq(str(t.animal_preview("pen_02")["reason"]), "need_feed", "tanpa pakan")
	var state := JSON.stringify(t.to_dict())
	var t2 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	check(t2.from_dict(t.to_dict()), "muat peternakan")
	check_eq(JSON.stringify(t2.to_dict()), state, "status sama setelah muat")
	var corrupt := t.to_dict()
	corrupt["livestock"]["animals"]["pen_01"]["species"] = "tak_ada"
	check(not t2.from_dict(corrupt), "peternakan rusak menolak seluruh muat")
	check_eq(JSON.stringify(t2.to_dict()), state, "status utuh setelah muat gagal")
