extends TestCase

func _clock() -> GameClock:
	return GameClock.new(DataRegistry.get_row("time_config", "default") if DataRegistry.has_row("time_config", "default") else {})


func _session(clock: GameClock) -> FarmingSession:
	var ids: Array = []
	for r in DataRegistry.rows("farm_plots"):
		ids.append(str(r["id"]))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), ids,
		DataRegistry.get_row("farm_config", "default"))


func run() -> void:
	# --- Data valid ---
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = it
		check(bool(it.get("provisional", false)), "item ditandai sementara: %s" % it["id"])
		check(int(it["stack_max"]) >= 1, "stack_max valid: %s" % it["id"])
	for c in DataRegistry.rows("crops"):
		check(items.has(str(c["seed_item"])) and items.has(str(c["harvest_item"])), "item tanaman ada: %s" % c["id"])
		check(bool(c.get("provisional", false)), "tanaman ditandai sementara: %s" % c["id"])
		check((c["stage_days"] as Array).size() >= 1, "tahap tumbuh ada: %s" % c["id"])
	var missing := 0
	for k in items:
		if tr(str(items[k]["name_key"])) == str(items[k]["name_key"]):
			missing += 1
	check_eq(missing, 0, "nama item punya terjemahan")
	check_eq(DataRegistry.rows("farm_plots").size(), 12, "12 petak uji")

	# --- Inventory ---
	var inv := Inventory.new(3, func(id): return {"a": 5, "t": 1}.get(id, 0))
	check_eq(inv.add("a", 7), 0, "7 item a muat (2 slot)")
	check_eq(inv.count("a"), 7, "jumlah a = 7")
	check_eq(inv.add("t", 5), 4, "alat tak bertumpuk: hanya 1 muat")
	check_eq(inv.count("t"), 1, "alat 1")
	check_eq(inv.add("a", 3), 0, "mengisi tumpukan yang ada")
	check_eq(inv.add("a", 1), 1, "penuh: item ditolak sisa 1")
	check_eq(inv.add("zzz", 1), 1, "item tak dikenal ditolak")
	check(not inv.remove("a", 11), "tak cukup: tidak mengurangi apa pun")
	check_eq(inv.count("a"), 10, "jumlah tetap setelah gagal")
	check(inv.remove("a", 9), "kurangi 9")
	check_eq(inv.count("a"), 1, "sisa 1")
	check(inv.can_add("a", 4), "ruang a tersisa")
	var dump := inv.to_dict()
	var inv2 := Inventory.new(3, func(id): return {"a": 5, "t": 1}.get(id, 0))
	check(inv2.from_dict(dump), "muat inventory valid")
	check_eq(inv2.count("a"), 1, "isi sama setelah muat")
	var bad := dump.duplicate(true)
	bad["slots"][0] = {"item": "a", "count": 99}
	check(not inv2.from_dict(bad), "jumlah melebihi stack ditolak")
	check_eq(inv2.count("a"), 1, "status tidak berubah saat muat gagal")
	check(not inv2.from_dict({"v": 1, "slots": []}), "jumlah slot salah ditolak")

	# --- Petak ---
	var defs := {}
	for c in DataRegistry.rows("crops"):
		defs[str(c["id"])] = c
	var p := FarmPlot.new("x")
	check(not bool(p.plant("crop_test_a", "season_1", defs)["ok"]), "tanam sebelum dicangkul ditolak")
	check(bool(p.till()["ok"]), "cangkul")
	check(not bool(p.till()["ok"]), "cangkul dua kali ditolak")
	check(not bool(p.plant("crop_test_a", "season_3", defs)["ok"]), "salah musim ditolak")
	check(bool(p.plant("crop_test_a", "season_1", defs)["ok"]), "tanam")
	check(not bool(p.plant("crop_test_a", "season_1", defs)["ok"]), "petak terisi")
	p.advance_day(false, defs)
	check_eq(p.stage_days, 0, "tanpa siram tidak tumbuh")
	check(bool(p.water(defs)["ok"]), "siram")
	check(not bool(p.water(defs)["ok"]), "siram dua kali ditolak")
	p.advance_day(false, defs)
	check_eq(p.stage, 1, "hari 1 selesai (tahap 0 = 1 hari) -> tahap 1")
	check(not p.watered, "penyiraman direset tiap hari")
	check(not bool(p.harvest(defs)["ok"]), "belum siap panen")
	for i in 4:
		p.water(defs)
		p.advance_day(false, defs)
	check(p.is_ready(defs), "siap setelah 1+2+2 hari tersiram")
	var snap := p.to_dict()
	var h := p.harvest(defs)
	check(bool(h["ok"]) and h["item"] == "produce_test_a" and int(h["amount"]) == 1, "panen memberi hasil")
	check(p.tilled and not p.has_crop(), "setelah panen tetap tergemburkan, tanpa tanaman")
	var q := FarmPlot.new("x")
	check(q.from_dict(snap, defs) and q.is_ready(defs), "muat petak siap panen")
	var broken := snap.duplicate()
	broken["stage"] = 99
	check(not FarmPlot.new("x").from_dict(broken, defs), "tahap di luar rentang ditolak")
	var rain := FarmPlot.new("r")
	rain.till()
	rain.plant("crop_test_a", "season_1", defs)
	rain.advance_day(true, defs)
	check_eq(rain.stage, 1, "hujan menyiram otomatis")

	# --- Sesi: alur lengkap ---
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var s := _session(clock)
	check(s.inventory.has("tool_hoe") and s.inventory.count("seed_test_a") == 6, "item awal dari data")
	var season := clock.season_id()
	check_eq(season, "season_1", "musim awal")
	var seq: Array[String] = []
	for i in 3:
		var r := s.act_on("plot_01")
		check(bool(r["ok"]), "aksi %d berhasil" % i)
		seq.append(str(r["action"]))
	check_eq(seq, ["till", "plant", "water"], "urutan aksi kontekstual")
	check_eq(s.inventory.count("seed_test_a"), 5, "benih berkurang 1")
	check_eq(str(s.act_on("plot_01")["reason"]), "already_watered", "tidak bisa siram dua kali")
	for d in 4:
		clock.add_minutes(clock.minutes_per_day())
		s.act_on("plot_01")  # siram tiap hari
	clock.add_minutes(clock.minutes_per_day())
	check(s.grid.plot("plot_01").is_ready(s.crop_defs), "tanaman siap setelah beberapa hari")
	check_eq(str(s.act_on("plot_01")["action"]), "harvest", "aksi panen")
	check_eq(s.inventory.count("produce_test_a"), 1, "hasil panen masuk inventory")
	check(not bool(s.act_on("tidak_ada")["ok"]), "petak tak dikenal ditolak")

	# Inventory penuh menahan panen tanpa kehilangan tanaman
	var s2 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	s2.act_on("plot_02"); s2.act_on("plot_02")
	var plot2 := s2.grid.plot("plot_02")
	plot2.stage = 3
	check(plot2.is_ready(s2.crop_defs), "disiapkan siap panen")
	s2.inventory.clear()
	for i in 24:
		s2.inventory.add("tool_hoe", 1)
	check_eq(str(s2.act_on("plot_02")["reason"]), "inventory_full", "tas penuh menolak panen")
	check(plot2.has_crop(), "tanaman tidak hilang saat tas penuh")

	# Tanpa alat / benih
	var s3 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	s3.inventory.clear()
	check_eq(str(s3.act_on("plot_03")["reason"]), "need_hoe", "butuh cangkul")
	s3.inventory.add("tool_hoe", 1)
	s3.act_on("plot_03")
	check_eq(str(s3.act_on("plot_03")["reason"]), "need_seed", "butuh benih")

	# --- Simpan/muat lewat SaveService (determinisme, tanpa jam perangkat) ---
	var payload := s.to_dict()
	check_eq(SaveService.save_slot(2, {"farming": payload}), OK, "simpan ke slot")
	var back: Dictionary = SaveService.load_slot(2)
	var s4 := _session(GameClock.new(DataRegistry.get_row("time_config", "default")))
	check(s4.from_dict(back["farming"]), "muat sesi dari save")
	check_eq(JSON.stringify(s4.to_dict()), JSON.stringify(payload), "status identik setelah muat")
	var before := JSON.stringify(s4.to_dict())
	var corrupt := payload.duplicate(true)
	corrupt["grid"]["plots"]["plot_01"]["crop"] = "tanaman_tidak_ada"
	check(not s4.from_dict(corrupt), "save rusak ditolak")
	check_eq(JSON.stringify(s4.to_dict()), before, "status utuh setelah muat gagal")
	SaveService.delete_slot(2)
