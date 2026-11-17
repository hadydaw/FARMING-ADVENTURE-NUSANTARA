class_name BasicHud
extends CanvasLayer
## HUD dasar (teks): waktu, tanggal, musim, fase, prompt interaksi, joystick, tombol aksi,
## tombol kembali. Tanpa ikon final (ikon HUD B-005 menunggu ChatGPT); teks memakai
## tema UI sementara.

var _time_label: Label
var _prompt_label: Label
var _message_label: Label
var _inventory_label: Label
var _joystick: TouchJoystick
var _interact_button: ActionButton
var _message_timer := 0.0


func _ready() -> void:
	var safe := SafeAreaContainer.new()
	add_child(safe)
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	safe.add_child(root)

	_time_label = Label.new()
	root.add_child(_time_label)

	_prompt_label = Label.new()
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(_prompt_label)
	_prompt_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_MINSIZE, 24)
	_prompt_label.position.y -= 120

	_message_label = Label.new()
	_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(_message_label)
	_message_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_MINSIZE, 24)
	_message_label.position.y += 120

	_inventory_label = Label.new()
	root.add_child(_inventory_label)
	_inventory_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT, Control.PRESET_MODE_MINSIZE, 0)
	_inventory_label.position.y += 110

	var back := Button.new()
	back.text = tr("COMMON_BACK")
	back.size = Vector2(200, UiTheme.MIN_TOUCH_HEIGHT)
	root.add_child(back)
	back.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
	back.pressed.connect(func(): SceneManager.back())

	_joystick = TouchJoystick.new()
	_joystick.size = Vector2(380, 380)
	root.add_child(_joystick)
	_joystick.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT, Control.PRESET_MODE_KEEP_SIZE)

	_interact_button = ActionButton.new()
	_interact_button.action = &"interact"
	_interact_button.label_key = "ACT_INTERACT"
	_interact_button.size = Vector2.ONE * _interact_button.radius * 2.0
	root.add_child(_interact_button)
	_interact_button.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_KEEP_SIZE, 24)


func _process(delta: float) -> void:
	_time_label.text = time_text()
	if _message_timer > 0.0:
		_message_timer -= delta
		if _message_timer <= 0.0:
			_message_label.text = ""


func time_text() -> String:
	var c := GameTime.clock
	return "%s\n%s | %s" % [
		tr("HUD_DATE") % [c.day_index() + 1, c.time_text()],
		tr("PHASE_" + c.phase_id().to_upper()),
		tr("SEASON_" + str(c.season_index() + 1)),
	] + ("\n" + tr("HUD_PAUSED") if c.is_paused() else "")


func set_prompt(text: String) -> void:
	_prompt_label.text = text


func show_message(text: String, seconds: float = 2.0) -> void:
	_message_label.text = text
	_message_timer = seconds


func joystick() -> TouchJoystick:
	return _joystick


func interact_button() -> ActionButton:
	return _interact_button


func set_inventory_text(text: String) -> void:
	_inventory_label.text = text
