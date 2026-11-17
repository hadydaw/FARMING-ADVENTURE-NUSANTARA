extends Node
## Layanan input (autoload "InputService"), D-034 dan TECHNICAL_ARCHITECTURE.md bagian 7.
##
## - Membuat InputMap dari data (game/data/input_actions.json); aksi bersifat
##   dasar dan BUKAN daftar tombol final (D-034 menyatakan tombol per konteks masih terbuka).
## - Menggabungkan gerak dari keyboard/gamepad dan joystick sentuh menjadi satu vektor.
## - Tombol Back Android dan Escape diteruskan sebagai Events.back_requested.
## - Kontrol sentuh memakai penanganan multi-touch sendiri (joystick + tombol aksi bersamaan).

var touch_move: Vector2 = Vector2.ZERO
var last_source: String = ""


func _ready() -> void:
	ensure_actions()
	# Di desktop, mouse diemulasikan menjadi sentuhan agar kontrol sentuh dapat diuji.
	Input.set_emulate_touch_from_mouse(not DisplayServer.is_touchscreen_available())


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		Events.back_requested.emit()


func _input(event: InputEvent) -> void:
	var source := ""
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		source = "touch"
	elif event is InputEventKey:
		source = "keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		source = "gamepad"
	if source != "" and source != last_source:
		last_source = source
		Events.input_source_changed.emit(source)
	if event.is_action_pressed("cancel") and not event.is_echo():
		Events.back_requested.emit()


## Membuat ulang aksi dari tabel data (idempoten). Mengembalikan jumlah aksi.
func ensure_actions() -> int:
	var count := 0
	for row_variant in DataRegistry.rows("input_actions"):
		var row: Dictionary = row_variant
		var action := StringName(str(row["id"]))
		if InputMap.has_action(action):
			InputMap.erase_action(action)
		InputMap.add_action(action, 0.2)
		for ev in row.get("events", []):
			var event := _make_event(ev)
			if event != null:
				InputMap.action_add_event(action, event)
		count += 1
	return count


func _make_event(ev: Dictionary) -> InputEvent:
	match str(ev.get("type", "")):
		"key":
			var keycode := OS.find_keycode_from_string(str(ev.get("key", "")))
			if keycode == KEY_NONE:
				push_error("InputService: tombol tidak dikenal '%s'" % ev.get("key", ""))
				return null
			var key := InputEventKey.new()
			key.physical_keycode = keycode
			return key
		"joy_axis":
			var motion := InputEventJoypadMotion.new()
			motion.axis = int(ev.get("axis", 0)) as JoyAxis
			motion.axis_value = float(ev.get("value", 1.0))
			return motion
		"joy_button":
			var button := InputEventJoypadButton.new()
			button.button_index = int(ev.get("index", 0)) as JoyButton
			return button
	return null


## Dipanggil joystick sentuh. Nilai dibatasi ke panjang <= 1.
func set_touch_move(vector: Vector2) -> void:
	touch_move = vector.limit_length(1.0)


## Vektor gerak gabungan (keyboard/gamepad + sentuh), panjang <= 1.
func move_vector() -> Vector2:
	var v := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if touch_move.length() > v.length():
		v = touch_move
	return v.limit_length(1.0)
