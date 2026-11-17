class_name BasicHud
extends CanvasLayer
## HUD dasar (teks): waktu, tanggal, musim, fase, prompt interaksi, joystick, tombol aksi,
## tombol kembali. Tanpa ikon final (ikon HUD B-005 menunggu ChatGPT); teks memakai
## tema UI sementara.

var _time_label: Label
var _prompt_label: Label
var _message_label: Label
var _inventory_label: Label
var _weather_label: Label
var _vitality_label: Label
var _joystick: TouchJoystick
var _interact_button: ActionButton
var _message_timer := 0.0
var _bag_panel: PanelContainer
var _bag_grid: GridContainer

signal save_pressed
signal load_pressed


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

	_weather_label = Label.new()
	root.add_child(_weather_label)
	_weather_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT, Control.PRESET_MODE_MINSIZE, 0)
	_weather_label.position.y += 80

	_vitality_label = Label.new()
	root.add_child(_vitality_label)
	_vitality_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT, Control.PRESET_MODE_MINSIZE, 0)
	_vitality_label.position.y += 165

	var back := Button.new()
	back.text = tr("COMMON_BACK")
	back.size = Vector2(200, UiTheme.MIN_TOUCH_HEIGHT)
	root.add_child(back)
	back.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
	back.pressed.connect(func(): SceneManager.back())

	var col := VBoxContainer.new()
	root.add_child(col)
	col.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_MINSIZE, 0)
	col.position.y += UiTheme.MIN_TOUCH_HEIGHT + 60
	col.position.x -= 200
	for spec in [["HUD_SAVE", "save"], ["HUD_LOAD", "load"], ["HUD_BAG", "bag"]]:
		var b := Button.new()
		b.text = tr(spec[0])
		b.custom_minimum_size = Vector2(200, UiTheme.MIN_TOUCH_HEIGHT)
		b.name = "Btn_" + spec[1]
		col.add_child(b)
		match spec[1]:
			"save": b.pressed.connect(func(): save_pressed.emit())
			"load": b.pressed.connect(func(): load_pressed.emit())
			"bag": b.pressed.connect(func(): _bag_panel.visible = not _bag_panel.visible)

	_bag_panel = PanelContainer.new()
	_bag_panel.visible = false
	root.add_child(_bag_panel)
	_bag_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	_bag_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_bag_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_bag_grid = GridContainer.new()
	_bag_grid.columns = 6
	_bag_panel.add_child(_bag_grid)

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


func bag_visible() -> bool:
	return _bag_panel.visible


func toggle_bag() -> void:
	_bag_panel.visible = not _bag_panel.visible


## Menggambar ulang kisi tas: tiap slot satu kotak teks (ikon item menunggu aset C-00x).
func set_bag_slots(lines: Array) -> void:
	for c in _bag_grid.get_children():
		c.queue_free()
	for t in lines:
		var l := Label.new()
		l.text = str(t)
		l.custom_minimum_size = Vector2(150, 70)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_bag_grid.add_child(l)


func set_weather_text(text: String) -> void:
	_weather_label.text = tr("HUD_WEATHER") + ": " + text


func set_vitality_text(text: String) -> void:
	_vitality_label.text = text
