extends TestCase


func run() -> void:
	var rows := DataRegistry.rows("input_actions")
	check_eq(InputService.ensure_actions(), rows.size(), "semua aksi dibuat dari data")
	for row in rows:
		var action := StringName(str((row as Dictionary)["id"]))
		check(InputMap.has_action(action), "aksi '%s' ada" % action)
		check(not InputMap.action_get_events(action).is_empty(), "aksi '%s' punya event" % action)
	# Idempoten: dipanggil lagi tidak menggandakan event.
	var before := InputMap.action_get_events(&"move_left").size()
	InputService.ensure_actions()
	check_eq(InputMap.action_get_events(&"move_left").size(), before, "ensure_actions idempoten")

	# Joystick sentuh dibatasi dan digabung.
	InputService.set_touch_move(Vector2(3, 4))
	check_near(InputService.touch_move.length(), 1.0, "vektor sentuh dibatasi panjang 1")
	InputService.set_touch_move(Vector2.ZERO)
	check_near(InputService.move_vector().length(), 0.0, "tanpa input = nol")

	InputService.set_touch_move(Vector2(0.5, 0))
	check_near(InputService.move_vector().x, 0.5, "sentuh terbaca")
	Input.action_press("move_left")
	check_near(InputService.move_vector().x, -1.0, "keyboard lebih kuat mengalahkan sentuh")
	Input.action_release("move_left")
	InputService.set_touch_move(Vector2.ZERO)

	# Back diteruskan sebagai event bus.
	var received := [false]
	var on_back := func(): received[0] = true
	Events.back_requested.connect(on_back)
	var ev := InputEventAction.new()
	ev.action = &"cancel"
	ev.pressed = true
	InputService._input(ev)
	check(received[0], "aksi cancel memicu Events.back_requested")
	Events.back_requested.disconnect(on_back)
