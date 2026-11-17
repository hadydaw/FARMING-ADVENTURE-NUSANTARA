extends TestCase


func run() -> void:
	SceneManager.quit_when_empty = false
	SceneManager.current_id = ""
	SceneManager._history.clear()

	var failures: Array[String] = []
	var on_fail := func(id: String, reason: String): failures.append("%s:%s" % [id, reason])
	Events.scene_change_failed.connect(on_fail)

	await SceneManager.go("main_menu", false, false)
	check_eq(SceneManager.current_id, "main_menu", "boot -> main_menu")
	check(SceneManager.history().is_empty(), "tanpa riwayat dari boot")
	check_eq(tree.current_scene.name, "MainMenu", "scene aktif = MainMenu")

	await SceneManager.go("settings", true, false)
	check_eq(SceneManager.current_id, "settings", "pindah ke settings")
	check_eq(SceneManager.history(), ["main_menu"] as Array[String], "riwayat berisi main_menu")
	check_eq(tree.current_scene.name, "SettingsScreen", "scene aktif = SettingsScreen")

	# Layar pengaturan dibangun dari skema data.
	await wait_frames(2)
	var screen := tree.current_scene
	var viewport_size := tree.root.get_visible_rect().size
	var safe: Control = screen.get_child(0)
	check_near(safe.size.x, viewport_size.x, "pengaturan: wadah area aman selebar viewport", 1.0)
	check_near(safe.size.y, viewport_size.y, "pengaturan: wadah area aman setinggi viewport", 1.0)
	var rows_box: VBoxContainer = screen._rows_box
	check_eq(screen.current_category(), "general", "kategori awal = general")
	check_eq(rows_box.get_child_count(), GameSettings.rows_in("general").size(), "baris umum sesuai skema")
	screen.select_category("audio")
	await wait_frames(2)
	check_eq(rows_box.get_child_count(), 3, "kategori audio = 3 baris")
	var slider: HSlider = null
	for child in rows_box.get_child(0).get_children():
		if child is HSlider:
			slider = child
	check(slider != null, "baris audio punya slider")
	if slider != null:
		slider.value = 0.3
		check_near(float(GameSettings.get_value("music_volume")), 0.3, "slider mengubah pengaturan")
	GameSettings.reset_all()

	# Diagnostik dapat dibuka dan dirender beberapa frame.
	await SceneManager.go("foundation_test", true, false)
	await wait_frames(3)
	check_eq(tree.current_scene.name, "FoundationTest", "scene diagnostik aktif")
	check(tree.current_scene.info_text().contains("Renderer"), "info diagnostik tampil")
	# Tata letak landscape: joystick kiri-bawah, tombol aksi kanan-bawah, semua di dalam layar.
	var vp := tree.root.get_visible_rect()
	var js: Control = tree.current_scene._joystick
	var js_rect := js.get_global_rect()
	check(vp.encloses(js_rect), "joystick di dalam layar: %s" % str(js_rect))
	check(js_rect.get_center().x < vp.size.x * 0.35 and js_rect.get_center().y > vp.size.y * 0.5, "joystick di kiri-bawah")
	for b in tree.current_scene._buttons:
		var r: Rect2 = (b as Control).get_global_rect()
		check(vp.encloses(r), "tombol aksi di dalam layar: %s" % str(r))
		check(r.get_center().x > vp.size.x * 0.6 and r.get_center().y > vp.size.y * 0.5, "tombol aksi di kanan-bawah")
	check_eq(SceneManager.history(), ["main_menu", "settings"] as Array[String], "riwayat bertambah")

	# Back menelusuri riwayat.
	await SceneManager.back()
	check_eq(SceneManager.current_id, "settings", "back -> settings")
	await SceneManager.back()
	check_eq(SceneManager.current_id, "main_menu", "back -> main_menu")
	await SceneManager.back()
	check_eq(SceneManager.current_id, "main_menu", "back di dasar tidak keluar saat quit dinonaktifkan")

	# Galat.
	await SceneManager.go("tidak_ada", true, false)
	check(failures.has("tidak_ada:unknown_scene"), "ID tak dikenal dilaporkan")
	check_eq(SceneManager.current_id, "main_menu", "scene tetap saat gagal")

	Events.scene_change_failed.disconnect(on_fail)
