extends TestCase

func _social() -> SocialState:
	var ids: Array = []
	for n in DataRegistry.rows("npcs"):
		ids.append(str(n["id"]))
	return SocialState.new(ids, 100, 0)


func run() -> void:
	# Data
	var locs: Array = []
	for l in DataRegistry.rows("npc_locations"):
		locs.append(str(l["id"]))
	for n in DataRegistry.rows("npcs"):
		check(bool(n.get("provisional", false)), "NPC ditandai sementara: %s" % n["id"])
		check_eq(ScheduleResolver.validate(n, locs), [] as Array[String], "jadwal valid: %s" % n["id"])
		check(tr(str(n["name_key"])) != str(n["name_key"]), "nama NPC punya terjemahan")
	var keys_missing := 0
	for d in DataRegistry.rows("dialogs"):
		check(bool(d.get("provisional", false)), "dialog sementara: %s" % d["id"])
		check(DataRegistry.has_row("npcs", str(d["npc"])), "dialog merujuk NPC ada: %s" % d["id"])
		for k in d["lines"]:
			if tr(str(k)) == str(k):
				keys_missing += 1
		for c in d["choices"]:
			if tr(str(c["text_key"])) == str(c["text_key"]):
				keys_missing += 1
			var nx := str(c["next"])
			check(nx == "" or DataRegistry.has_row("dialogs", nx), "tujuan pilihan ada: %s" % d["id"])
	check_eq(keys_missing, 0, "semua teks dialog diterjemahkan")

	# Validasi jadwal jelek terdeteksi
	var bad := {"id": "x", "schedule": [{"from": 0, "to": 10, "location": "loc_field", "activity": "a"}, {"from": 12, "to": 24, "location": "loc_field", "activity": "a"}]}
	check(not ScheduleResolver.validate(bad, locs).is_empty(), "celah jadwal terdeteksi")
	var bad2 := {"id": "y", "schedule": [{"from": 0, "to": 24, "location": "tak_ada", "activity": "a"}]}
	check(not ScheduleResolver.validate(bad2, locs).is_empty(), "lokasi tak dikenal terdeteksi")

	# Resolver
	var a := DataRegistry.get_row("npcs", "npc_test_a")
	check_eq(ScheduleResolver.resolve(a, 3, false)["location"], "loc_home_a", "dini hari di rumah")
	check_eq(ScheduleResolver.resolve(a, 6, false)["location"], "loc_field", "batas jam 6 = jadwal baru")
	check_eq(ScheduleResolver.resolve(a, 11, false)["activity"], "work", "pagi bekerja")
	check_eq(ScheduleResolver.resolve(a, 23, false)["location"], "loc_home_a", "malam di rumah")
	var rain := ScheduleResolver.resolve(a, 9, true)
	check_eq(rain["location"], "loc_home_a", "hujan: berteduh di rumah")
	check_eq(rain["activity"], "shelter", "aktivitas berteduh")
	check_eq(JSON.stringify(ScheduleResolver.resolve(a, 14, false)), JSON.stringify(ScheduleResolver.resolve(a, 14, false)), "deterministik")

	# SocialState
	var so := _social()
	check_eq(so.change_friendship("npc_test_a", 5), 5, "friendship naik")
	check_eq(so.change_friendship("npc_test_a", 500), 95, "dibatasi max")
	check_eq(so.change_friendship("npc_test_a", -500), -100, "dibatasi 0")
	check_eq(so.change_friendship("tak_ada", 5), 0, "NPC tak dikenal diabaikan")
	so.change_friendship("npc_test_b", 7)
	so.mark_seen("dlg_a_talk", 3)
	check(so.seen_on_day("dlg_a_talk", 3) and not so.seen_on_day("dlg_a_talk", 4), "penanda per hari")
	var snap := so.to_dict()
	var so2 := _social()
	check(so2.from_dict(snap) and so2.friendship("npc_test_b") == 7 and so2.seen_on_day("dlg_a_talk", 3), "muat sosial")
	var broken := snap.duplicate(true)
	broken["friendship"]["npc_test_a"] = 9999
	check(not so2.from_dict(broken), "nilai di luar rentang ditolak")
	var broken2 := snap.duplicate(true)
	broken2["friendship"].erase("npc_test_b")
	check(not so2.from_dict(broken2), "NPC kurang ditolak")
	check_eq(so2.friendship("npc_test_b"), 7, "status utuh setelah gagal")

	# Dialog: pemilihan
	var st := _social()
	var dr := DialogRunner.new(DataRegistry.rows("dialogs"), st)
	var ctx := {"hour": 9, "weather": "clear", "season": "season_1", "day": 0}
	check_eq(dr.select("npc_test_a", ctx)["id"], "dlg_a_talk", "dialog biasa dipilih")
	check_eq(dr.select("npc_test_a", {"hour": 9, "weather": "rain", "season": "season_1", "day": 0})["id"], "dlg_a_rain", "prioritas: hujan menang")
	check_eq(dr.select("npc_test_b", ctx)["id"], "dlg_b_morning", "syarat jam pagi")
	check_eq(dr.select("npc_test_b", {"hour": 14, "weather": "clear", "season": "season_1", "day": 0})["id"], "dlg_b_other", "di luar jam pagi: dialog lain")
	check(dr.select("npc_tak_ada", ctx).is_empty(), "NPC tanpa dialog -> kosong")

	# Dialog: alur, pilihan, friendship, tidak berulang
	var lines: Array = []
	var chs: Array = []
	var ended := [false]
	dr.line_changed.connect(func(k, c): lines.append(k); chs.append(c.size()))
	dr.ended.connect(func(): ended[0] = true)
	check(dr.start("npc_test_a", ctx), "mulai dialog")
	check(not dr.start("npc_test_a", ctx), "tidak bisa mulai saat aktif")
	check_eq(lines, ["DLG_TEST_HELLO"], "baris pertama")
	check(not dr.choose(0, 0), "pilihan belum sah sebelum baris terakhir")
	dr.advance(0)
	check_eq(lines.back(), "DLG_TEST_ASK", "baris kedua")
	check_eq(chs.back(), 2, "dua pilihan tampil di baris terakhir")
	check(not dr.choose(5, 0), "indeks pilihan tidak valid ditolak")
	check(dr.choose(0, 0), "pilih ramah")
	check_eq(st.friendship("npc_test_a"), 2, "friendship bertambah")
	check_eq(lines.back(), "DLG_TEST_THANKS", "lanjut ke dialog tujuan")
	dr.advance(0)
	check(ended[0] and not dr.is_active(), "dialog selesai")
	check_eq(dr.select("npc_test_a", ctx)["id"], "dlg_a_repeat", "setelah dibicarakan hari ini: dialog ulang")
	var ctx2 := ctx.duplicate()
	ctx2["day"] = 1
	check_eq(dr.select("npc_test_a", ctx2)["id"], "dlg_a_talk", "hari berikutnya dialog biasa kembali")
	st.change_friendship("npc_test_a", 1)
	check_eq(dr.select("npc_test_a", ctx2)["id"], "dlg_a_friend", "syarat friendship memunculkan dialog teman")
