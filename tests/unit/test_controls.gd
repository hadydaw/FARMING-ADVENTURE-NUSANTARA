extends TestCase


func _touch(index: int, pos: Vector2, pressed: bool) -> InputEventScreenTouch:
	var e := InputEventScreenTouch.new()
	e.index = index
	e.position = pos
	e.pressed = pressed
	return e


func _drag(index: int, pos: Vector2) -> InputEventScreenDrag:
	var e := InputEventScreenDrag.new()
	e.index = index
	e.position = pos
	return e


func run() -> void:
	var host := Control.new()
	tree.root.add_child(host)

	var joystick := TouchJoystick.new()
	joystick.follow_settings = false
	joystick.dead_zone = 0.2
	joystick.size_scale = 1.0
	joystick.position = Vector2(100, 300)
	joystick.size = Vector2(400, 400)
	host.add_child(joystick)

	var button_a := ActionButton.new()
	button_a.action = &"interact"
	button_a.position = Vector2(900, 400)
	button_a.size = Vector2(112, 112)
	host.add_child(button_a)
	var button_b := ActionButton.new()
	button_b.action = &"action_primary"
	button_b.position = Vector2(1050, 400)
	button_b.size = Vector2(112, 112)
	host.add_child(button_b)
	await wait_frames(1)

	var center := joystick.global_position + joystick.size / 2.0

	# Joystick tetap: dorong penuh ke kanan.
	joystick._input(_touch(0, center + Vector2(100, 0), true))
	check(joystick.is_active(), "joystick aktif saat disentuh di dalam area")
	check_near(joystick.vector.x, 1.0, "dorong penuh kanan = 1")
	check_near(InputService.move_vector().x, 1.0, "InputService menerima gerak")
	# Seret ke bawah-kiri.
	joystick._input(_drag(0, center + Vector2(-70, 70)))
	check(joystick.vector.x < 0 and joystick.vector.y > 0, "arah bawah-kiri")
	# Di dalam zona mati = nol.
	joystick._input(_drag(0, center + Vector2(10, 0)))
	check_near(joystick.vector.length(), 0.0, "zona mati = nol")
	# Jari kedua diabaikan saat jari pertama aktif.
	joystick._input(_touch(1, center + Vector2(0, -100), true))
	check_near(joystick.vector.length(), 0.0, "jari kedua tidak mengubah joystick")
	# Lepas.
	joystick._input(_touch(1, center, false))
	check(joystick.is_active(), "melepas jari lain tidak melepas joystick")
	joystick._input(_touch(0, center, false))
	check(not joystick.is_active(), "lepas jari = tidak aktif")
	check_near(InputService.move_vector().length(), 0.0, "gerak kembali nol")

	# Sentuhan jauh di luar joystick tetap tidak diterima.
	joystick._input(_touch(0, Vector2(1200, 50), true))
	check(not joystick.is_active(), "sentuhan di luar area ditolak")

	# Joystick mengambang: titik sentuh menjadi pusat.
	joystick.mode = TouchJoystick.Mode.FLOATING
	var start := joystick.global_position + Vector2(50, 50)
	joystick._input(_touch(0, start, true))
	check(joystick.is_active(), "mengambang menerima sentuhan di mana saja di area")
	joystick._input(_drag(0, start + Vector2(0, -100)))
	check_near(joystick.vector.y, -1.0, "mengambang: dorong ke atas = -1")
	joystick._input(_touch(0, start, false))

	# Tombol aksi multi-touch bersama joystick.
	joystick.mode = TouchJoystick.Mode.FIXED
	joystick._input(_touch(0, center + Vector2(100, 0), true))
	var a_center := button_a.global_position + button_a.size / 2.0
	var b_center := button_b.global_position + button_b.size / 2.0
	button_a._input(_touch(1, a_center, true))
	button_b._input(_touch(2, b_center, true))
	check(Input.is_action_pressed("interact"), "tombol A menekan aksi interact")
	check(Input.is_action_pressed("action_primary"), "tombol B menekan aksi action_primary")
	check_near(joystick.vector.x, 1.0, "joystick tetap aktif bersamaan dengan 2 tombol")
	button_a._input(_touch(1, a_center, false))
	check(not Input.is_action_pressed("interact"), "lepas tombol A")
	check(Input.is_action_pressed("action_primary"), "tombol B masih ditekan")
	button_b._input(_touch(2, b_center, false))
	joystick._input(_touch(0, center, false))

	# Sentuhan di luar tombol ditolak.
	button_a._input(_touch(3, a_center + Vector2(300, 0), true))
	check(not button_a.pressed, "sentuhan jauh dari tombol ditolak")

	# Menyembunyikan tombol saat ditekan melepas aksi (tidak macet).
	button_a._input(_touch(4, a_center, true))
	check(Input.is_action_pressed("interact"), "tombol ditekan lagi")
	button_a.hide()
	check(not Input.is_action_pressed("interact"), "disembunyikan = aksi dilepas")
	button_a.show()

	host.queue_free()
	await wait_frames(1)
	check(not Input.is_action_pressed("interact"), "tidak ada aksi macet setelah dibersihkan")
