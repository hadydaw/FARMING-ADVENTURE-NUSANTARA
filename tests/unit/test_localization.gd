extends TestCase


func _scan(dir: String, into: Dictionary) -> void:
	for f in DirAccess.get_files_at(dir):
		if f.ends_with(".gd") or f.ends_with(".json"):
			var text := FileAccess.get_file_as_string("%s/%s" % [dir, f])
			var regex := RegEx.create_from_string("\\b(?:tr\\(|label_key\\s*[=:]\\s*|\"label_key\":\\s*|\"[a-z_]+\":\\s*)\"([A-Z][A-Z0-9_]+)\"")
			for m in regex.search_all(text):
				into[m.get_string(1)] = "%s/%s" % [dir, f]
	for d in DirAccess.get_directories_at(dir):
		_scan("%s/%s" % [dir, d], into)


func run() -> void:
	# Kunci terdefinisi dengan id dan en berisi.
	var csv := FileAccess.open("res://game/i18n/translations.csv", FileAccess.READ)
	var defined: Dictionary = {}
	var header := csv.get_csv_line()
	check_eq(header, PackedStringArray(["keys", "id", "en"]), "header CSV keys,id,en")
	while not csv.eof_reached():
		var row := csv.get_csv_line()
		if row.size() < 3 or row[0] == "":
			continue
		check(not defined.has(row[0]), "kunci ganda: %s" % row[0])
		defined[row[0]] = row
		check(row[1].strip_edges() != "", "id kosong: %s" % row[0])
		check(row[2].strip_edges() != "", "en kosong: %s" % row[0])
		check_eq(row[1].count("%"), row[2].count("%"), "jumlah placeholder id/en sama: %s" % row[0])

	# Semua kunci yang dipakai kode/data harus ada.
	var used: Dictionary = {}
	_scan("res://game", used)
	for key in used:
		if key.ends_with("_"):
			continue # awalan kunci dinamis (mis. SET_CAT_), diperiksa terpisah di bawah
		check(defined.has(key), "kunci '%s' dipakai di %s tetapi tidak terdefinisi" % [key, used[key]])

	# Kunci dinamis: kategori pengaturan dan label opsi.
	for category in GameSettings.categories():
		check(defined.has("SET_CAT_" + category.to_upper()), "kunci kategori untuk '%s'" % category)
	for row in GameSettings.rows():
		var r: Dictionary = row
		check(defined.has(str(r["label_key"])), "label_key %s" % r["label_key"])
		for k in (r.get("option_keys", {}) as Dictionary).values():
			check(defined.has(str(k)), "option_key %s" % k)

	# Terjemahan termuat untuk kedua bahasa dan berbeda.
	TranslationServer.set_locale("id")
	var id_text := tr("MENU_SETTINGS")
	TranslationServer.set_locale("en")
	var en_text := tr("MENU_FOUNDATION_TEST")
	check_eq(id_text, "Pengaturan", "id termuat")
	check_eq(en_text, "Foundation Test (diagnostics)", "en termuat")
	TranslationServer.set_locale("id")
	check_eq(str(ProjectSettings.get_setting("internationalization/locale/fallback")), "en", "fallback en")
