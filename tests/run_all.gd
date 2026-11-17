extends SceneTree
## Menjalankan semua uji di tests/unit/test_*.gd secara headless.
##   godot --headless --path . --script res://tests/run_all.gd
## Kode keluar 0 bila semua lulus, 1 bila ada yang gagal.

const TEST_PATH := "res://tests/unit"
const SETTINGS_TEST_PATH := "user://test_run_settings.cfg"


func _initialize() -> void:
	_run()


func _run() -> void:
	# Pengaturan nyata diarahkan ke berkas uji agar tidak menyentuh data pemain.
	# (Autoload dirujuk lewat node karena skrip utama dikompilasi sebelum autoload terdaftar.)
	# Beri satu frame agar _ready semua autoload (mis. DataRegistry) sudah berjalan.
	await process_frame
	var settings: Node = root.get_node("GameSettings")
	settings.path = SETTINGS_TEST_PATH
	settings.reset_all()

	var files: Array[String] = []
	for f in DirAccess.get_files_at(TEST_PATH):
		if f.begins_with("test_") and f.ends_with(".gd"):
			files.append(f)
	files.sort()

	var total_checks := 0
	var total_failures := 0
	for f in files:
		var script := load("%s/%s" % [TEST_PATH, f]) as GDScript
		if script == null or not script.can_instantiate():
			total_failures += 1
			printerr("  GAGAL: %s tidak dapat dimuat (galat kompilasi)" % f)
			continue
		var t: TestCase = script.new()
		t.tree = self
		await t.run()
		total_checks += t.checks
		total_failures += t.failures.size()
		print("UJI %-28s %3d pemeriksaan, %d gagal" % [f, t.checks, t.failures.size()])
		for failure in t.failures:
			printerr("  GAGAL: ", failure)

	for p in [SETTINGS_TEST_PATH, SETTINGS_TEST_PATH + ".bak", SETTINGS_TEST_PATH + ".tmp"]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)
	TranslationServer.set_locale("id")

	print("TOTAL: %d berkas uji, %d pemeriksaan, %d gagal" % [files.size(), total_checks, total_failures])
	print("UJI UNIT: LULUS" if total_failures == 0 else "UJI UNIT: GAGAL")
	quit(0 if total_failures == 0 else 1)
