extends TestCase

func run() -> void:
	await SceneManager.go("systems_test", true, false)
	await wait_frames(3)
	var scene: Node = tree.current_scene
	check_eq(scene.name, "SystemsTest", "scene uji sistem aktif")
	check(scene.info_text().contains("Day") or scene.info_text().contains("Hari"), "info waktu tampil")

	# Joystick menggerakkan target relatif kamera; interaksi memicu penanda terdekat.
	var start: Vector3 = scene.target.global_position
	InputService.set_touch_move(Vector2(0, -1))
	await wait_frames(30)
	InputService.set_touch_move(Vector2.ZERO)
	check(scene.target.global_position.z < start.z - 0.1, "maju menggerakkan target ke -Z")
	check(scene.rig.target_position.is_equal_approx(scene.target.global_position), "kamera mengikuti target")

	scene.target.global_position = Vector3(0, 0, -3.3)
	scene._facing = Vector3(0, 0, -1)
	await wait_frames(3)
	check(scene.sensor.current != null, "penanda terdeteksi di dekat target")
	check(scene.sensor.try_interact(), "interaksi dengan penanda berhasil")
	check_eq(scene._interact_count, 1, "hitungan interaksi bertambah")

	# Waktu berjalan lewat GameTime dan tampil di info.
	var before: int = GameTime.clock.total_minutes
	GameTime.clock.add_minutes(60)
	check_eq(GameTime.clock.total_minutes, before + 60, "tombol +1 jam memajukan waktu")

	# Tata letak: semua kontrol di dalam layar.
	var vp := tree.root.get_visible_rect()
	check(vp.encloses(scene._joystick.get_global_rect()), "joystick di dalam layar")
	GameTime.new_game()
	await SceneManager.go("main_menu", false, false)
