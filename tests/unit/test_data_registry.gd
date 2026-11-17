extends TestCase


func run() -> void:
	check(DataRegistry.load_errors.is_empty(), "tabel bawaan harus termuat tanpa galat: %s" % str(DataRegistry.load_errors))
	for table in DataRegistry.TABLES:
		check(DataRegistry.has_table(str(table)), "tabel '%s' harus ada" % table)

	# Semua scene terdaftar harus benar-benar ada.
	for id in DataRegistry.ids("scenes"):
		var path := str(DataRegistry.get_row("scenes", str(id))["path"])
		check(ResourceLoader.exists(path), "scene '%s' harus ada di %s" % [id, path])
	check(DataRegistry.has_row("scenes", "main_menu"), "scene main_menu terdaftar")
	check(not DataRegistry.has_row("scenes", "tidak_ada"), "scene fiktif tidak terdaftar")
	check(DataRegistry.get_row("scenes", "tidak_ada").is_empty(), "get_row fiktif = kosong")

	# Validasi parser.
	var ok := DataRegistry.parse_rows('[{"id":"a_1"},{"id":"b"}]')
	check((ok["errors"] as Array).is_empty(), "parser: data sah tanpa galat")
	check_eq((ok["rows"] as Array).size(), 2, "parser: 2 baris")
	var dup := DataRegistry.parse_rows('[{"id":"a"},{"id":"a"}]')
	check((dup["errors"] as Array).size() == 1, "parser: ID ganda terdeteksi")
	var bad_id := DataRegistry.parse_rows('[{"id":"Besar"},{"id":"1x"},{"id":""},{"nama":"x"}]')
	check_eq((bad_id["errors"] as Array).size(), 4, "parser: ID tidak valid terdeteksi")
	check(not (DataRegistry.parse_rows("{rusak")["errors"] as Array).is_empty(), "parser: JSON rusak")
	check(not (DataRegistry.parse_rows('{"id":"a"}')["errors"] as Array).is_empty(), "parser: akar bukan array")
	check(not (DataRegistry.parse_rows('[1,2]')["errors"] as Array).is_empty(), "parser: baris bukan objek")

	# Tabel baru dapat dimuat dan ID-nya unik; berkas hilang dilaporkan.
	var missing := DataRegistry.load_table("fiktif", "res://game/data/tidak_ada.json")
	check(not missing.is_empty(), "berkas hilang dilaporkan")
