extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"character_options": DataRegistry.rows("character_options")})


func run() -> void:
	for g in DataRegistry.rows("character_options"):
		check(bool(g.get("provisional", false)) and (g["choices"] as Array).size() >= 2, "grup valid: %s" % g["id"])
		for c in g["choices"]:
			check(str(c).begins_with("#") and str(c).length() == 7, "warna heks valid")
		check(tr(str(g["label_key"])) != str(g["label_key"]), "terjemahan")
	var s := _session()
	var ch := s.character
	check(ch.color("skin").is_equal_approx(Color("#f1c9a5")), "pilihan awal")
	check(ch.cycle("skin") and ch.choice_index("skin") == 1, "ganti pilihan")
	check(not ch.cycle("palsu"), "grup tak dikenal ditolak")
	for i in 10:
		ch.cycle("outfit")
	check_eq(ch.choice_index("outfit"), 10 % 6, "berputar")
	check(not ch.set_choice("skin", 99) and not ch.set_choice("skin", -1), "indeks luar rentang ditolak")
	check(ch.set_choice("skin", 3), "set langsung")
	# Simpan/muat
	var saved := s.to_dict()
	var s2 := _session()
	check(s2.from_dict(saved), "muat")
	check_eq(s2.character.choice_index("skin"), 3, "kulit dipulihkan")
	check_eq(s2.character.choice_index("outfit"), 4, "pakaian dipulihkan")
	# Rusak -> rollback
	var s3 := _session()
	s3.character.set_choice("skin", 2)
	var before := JSON.stringify(s3.to_dict())
	var bad := saved.duplicate(true)
	bad["character"]["choice"]["skin"] = 99
	check(not s3.from_dict(bad), "indeks rusak ditolak")
	check_eq(JSON.stringify(s3.to_dict()), before, "rollback utuh")
	var bad2 := saved.duplicate(true)
	bad2["character"]["choice"]["rambut"] = 1
	check(not s3.from_dict(bad2), "grup tak dikenal ditolak saat muat")
	# Save lama tanpa kunci: kembali ke bawaan
	var old := saved.duplicate(true)
	old.erase("character")
	check(s3.from_dict(old), "save lama termuat")
	check_eq(s3.character.choice_index("skin"), 0, "direset ke bawaan")
	# Mulai baru juga mereset
	s.reset()
	check_eq(s.character.choice_index("skin"), 0, "reset game baru")
