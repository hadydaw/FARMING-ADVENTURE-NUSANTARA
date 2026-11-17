extends TestCase

const PATH := "user://test_settings_unit.cfg"


func _fresh() -> Node:
	var s: Node = (load("res://game/core/game_settings.gd") as GDScript).new()
	s.path = PATH
	s.apply_effects = false
	var errors: Array[String] = s.setup(DataRegistry.rows("settings"))
	check(errors.is_empty(), "skema sah: %s" % str(errors))
	return s


func _cleanup() -> void:
	for p in [PATH, PATH + ".bak", PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


func run() -> void:
	_cleanup()
	var s := _fresh()

	check(s.categories().has("audio") and s.categories().has("controls"), "kategori ada")
	check_eq(s.get_value("language"), "en", "bahasa bawaan Inggris, tidak mengikuti bahasa perangkat")
	check_near(float(s.get_value("music_volume")), 0.8, "default volume musik")

	# Validasi dan pembatasan.
	check(s.set_value("music_volume", 2.0), "nilai di atas rentang diterima dan dibatasi")
	check_near(float(s.get_value("music_volume")), 1.0, "dibatasi ke max")
	check(s.set_value("music_volume", -3), "nilai di bawah rentang dibatasi")
	check_near(float(s.get_value("music_volume")), 0.0, "dibatasi ke min")
	check(s.set_value("music_volume", 0.37), "nilai dibulatkan ke step")
	check_near(float(s.get_value("music_volume")), 0.35, "snap step 0.05")
	check(not s.set_value("music_volume", "keras"), "tipe salah ditolak")
	check(not s.set_value("music_volume", NAN), "NaN ditolak")
	check(not s.set_value("language", "xx"), "opsi tak dikenal ditolak")
	check(not s.set_value("tidak_ada", 1), "ID tak dikenal ditolak")
	check(s.set_value("language", "en") and s.get_value("language") == "en", "enum valid diterima")

	# Persistensi atomik.
	check_eq(s.flush(), OK, "flush OK")
	var s2 := _fresh()
	check_eq(s2.load_from_disk(), "main", "muat dari berkas utama")
	check_near(float(s2.get_value("music_volume")), 0.35, "nilai tersimpan terbaca")
	check_eq(s2.get_value("language"), "en", "bahasa tersimpan terbaca")

	# Perubahan kedua membuat cadangan; berkas utama rusak -> pulih dari cadangan.
	check(s2.set_value("sfx_volume", 0.5), "ubah lagi")
	check_eq(s2.flush(), OK, "flush kedua")
	check(FileAccess.file_exists(PATH + ".bak"), "cadangan .bak dibuat")
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string("[rusak")
	f = null
	var s3 := _fresh()
	check_eq(s3.load_from_disk(), "backup", "pulih dari cadangan")
	check_eq(s3.get_value("language"), "en", "nilai dari cadangan terbaca")

	# Kunci asing dan nilai tidak valid di berkas diabaikan.
	var cfg := ConfigFile.new()
	cfg.set_value("settings", "kunci_asing", 5)
	cfg.set_value("settings", "music_volume", 99.0)
	cfg.set_value("settings", "language", "xx")
	cfg.save(PATH)
	var s4 := _fresh()
	s4.load_from_disk()
	check_near(float(s4.get_value("music_volume")), 1.0, "nilai berkas dibatasi")
	check(s4.get_value("language") != "xx", "bahasa tak valid diganti bawaan")
	check(s4.get_value("kunci_asing") == null, "kunci asing dibuang")

	# Tanpa berkas -> bawaan.
	_cleanup()
	var s5 := _fresh()
	check_eq(s5.load_from_disk(), "defaults", "tanpa berkas = bawaan")

	# Reset.
	s5.set_value("sfx_volume", 0.1)
	s5.reset_category("audio")
	check_near(float(s5.get_value("sfx_volume")), 0.8, "reset kategori")
	s5.set_value("text_scale", 1.4)
	s5.reset_all()
	check_near(float(s5.get_value("text_scale")), 1.0, "reset semua")

	# Skema rusak dilaporkan.
	var bad := _fresh()
	var errors: Array[String] = bad.setup([{"id": "x", "category": "a", "type": "float", "label_key": "K", "default": 1, "min": 5, "max": 1}])
	check(not errors.is_empty(), "skema min>max dilaporkan")
	errors = bad.setup([{"id": "y", "category": "a", "type": "enum", "options": ["a"], "label_key": "K", "default": "b"}])
	check(not errors.is_empty(), "default di luar options dilaporkan")
	errors = bad.setup([{"id": "z", "category": "a", "type": "aneh", "label_key": "K", "default": 1}])
	check(not errors.is_empty(), "tipe tak dikenal dilaporkan")

	for node in [s, s2, s3, s4, s5, bad]:
		(node as Node).free()
	_cleanup()
