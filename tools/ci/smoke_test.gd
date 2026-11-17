extends SceneTree
## Uji asap fondasi (headless). Jalankan:
##   godot --headless --path . --script res://tools/ci/smoke_test.gd
## Keluar dengan kode 0 bila lulus, 1 bila ada yang gagal.

var _failures: Array[String] = []


func _initialize() -> void:
	_test_save_service()
	_test_backend_client()
	_test_translations()
	_test_main_scene()

	if _failures.is_empty():
		print("SMOKE TEST: LULUS")
		quit(0)
	else:
		for f in _failures:
			printerr("GAGAL: ", f)
		print("SMOKE TEST: GAGAL (%d)" % _failures.size())
		quit(1)


func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _test_save_service() -> void:
	var script: GDScript = load("res://game/core/save_service.gd")
	_check(script != null and script.can_instantiate(), "save_service.gd harus bisa dimuat")
	if script == null or not script.can_instantiate():
		return
	var svc: Node = script.new()
	svc.delete_slot(0)
	_check(not svc.has_slot(0), "slot 0 harus kosong di awal")
	_check(svc.load_slot(0).is_empty(), "load slot kosong harus {}")

	_check(svc.save_slot(0, {"gold": 100, "nama": "Uji"}) == OK, "save pertama harus OK")
	var data: Dictionary = svc.load_slot(0)
	_check(int(data.get("gold", -1)) == 100, "payload gold harus kembali 100")
	_check(str(data.get("nama", "")) == "Uji", "payload nama harus kembali")
	_check(int(svc.slot_info(0).get("revision", 0)) == 1, "revision awal = 1")

	_check(svc.save_slot(0, {"gold": 250}) == OK, "save kedua harus OK")
	_check(int(svc.slot_info(0).get("revision", 0)) == 2, "revision naik jadi 2")
	_check(int(svc.load_slot(0).get("gold", -1)) == 250, "payload terbaru terbaca")

	# Simulasi file utama rusak -> harus pulih dari .bak (isi save pertama).
	var f := FileAccess.open(svc.slot_path(0), FileAccess.WRITE)
	f.store_string("{rusak")
	f = null
	_check(int(svc.load_slot(0).get("gold", -1)) == 100, "harus pulih dari cadangan .bak")

	_check(svc.save_slot(99, {}) == ERR_INVALID_PARAMETER, "slot di luar batas ditolak")
	svc.delete_slot(0)
	_check(not svc.has_slot(0), "slot terhapus")
	svc.free()


func _test_backend_client() -> void:
	var client := BackendClient.new()
	_check(not client.is_configured(), "backend default tidak terkonfigurasi")
	_check(client.sign_in().get("error") == BackendClient.ERR_NOT_IMPLEMENTED, "sign_in belum diimplementasi")


func _test_translations() -> void:
	TranslationServer.set_locale("id")
	_check(tr("MENU_SETTINGS") == "Pengaturan", "terjemahan id harus termuat")
	TranslationServer.set_locale("en")
	_check(tr("MENU_SETTINGS") == "Settings", "terjemahan en harus termuat")
	TranslationServer.set_locale("id")


func _test_main_scene() -> void:
	var scene: PackedScene = load(str(ProjectSettings.get_setting("application/run/main_scene")))
	_check(scene != null, "main scene harus bisa dimuat")
	_check(scene.can_instantiate(), "main scene harus bisa di-instantiate")
