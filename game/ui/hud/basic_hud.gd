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
var _dialog_panel: PanelContainer
var _dialog_label: Label
var _dialog_choices: VBoxContainer
var _dialog_next: Button
var _shop_panel: PanelContainer
var _shop_title: Label
var _shop_buy: VBoxContainer
var _shop_sell: VBoxContainer
var _menu_panel: PanelContainer
var _menu_title: Label
var _menu_list: VBoxContainer
var _minimap: MinimapView
var _map_panel: PanelContainer
var _map_big: MinimapView
var _map_info: Label
var _region_label: Label

signal dialog_next
signal dialog_choice(index: int)
signal shop_buy(item: String)
signal shop_sell(item: String)
signal shop_close
signal menu_pressed(id: String)
signal menu_closed
signal bag_use(item: String)
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
	for spec in [["HUD_SAVE", "save"], ["HUD_LOAD", "load"], ["HUD_BAG", "bag"], ["HUD_MAP", "map"]]:
		var b := Button.new()
		b.text = tr(spec[0])
		b.custom_minimum_size = Vector2(200, UiTheme.MIN_TOUCH_HEIGHT)
		b.name = "Btn_" + spec[1]
		col.add_child(b)
		match spec[1]:
			"save": b.pressed.connect(func(): save_pressed.emit())
			"load": b.pressed.connect(func(): load_pressed.emit())
			"bag": b.pressed.connect(func(): _bag_panel.visible = not _bag_panel.visible)
			"map": b.pressed.connect(func(): toggle_map())

	_bag_panel = PanelContainer.new()
	_bag_panel.visible = false
	root.add_child(_bag_panel)
	_bag_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	_bag_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_bag_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_bag_grid = GridContainer.new()
	_bag_grid.columns = 6
	_bag_panel.add_child(_bag_grid)

	_dialog_panel = PanelContainer.new()
	_dialog_panel.visible = false
	root.add_child(_dialog_panel)
	_dialog_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_MINSIZE, 20)
	_dialog_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_dialog_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	var dbox := VBoxContainer.new()
	dbox.custom_minimum_size = Vector2(900, 0)
	_dialog_panel.add_child(dbox)
	_dialog_label = Label.new()
	_dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_dialog_label.custom_minimum_size = Vector2(880, 80)
	dbox.add_child(_dialog_label)
	_dialog_choices = VBoxContainer.new()
	dbox.add_child(_dialog_choices)
	_dialog_next = Button.new()
	_dialog_next.text = tr("DLG_NEXT")
	_dialog_next.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
	_dialog_next.pressed.connect(func(): dialog_next.emit())
	dbox.add_child(_dialog_next)

	_shop_panel = PanelContainer.new()
	_shop_panel.visible = false
	root.add_child(_shop_panel)
	_shop_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	_shop_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_shop_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var sbox := VBoxContainer.new()
	_shop_panel.add_child(sbox)
	_shop_title = Label.new()
	sbox.add_child(_shop_title)
	var cols := HBoxContainer.new()
	cols.add_theme_constant_override("separation", 24)
	sbox.add_child(cols)
	_shop_buy = VBoxContainer.new()
	_shop_buy.custom_minimum_size = Vector2(420, 0)
	cols.add_child(_shop_buy)
	_shop_sell = VBoxContainer.new()
	_shop_sell.custom_minimum_size = Vector2(420, 0)
	cols.add_child(_shop_sell)
	var close := Button.new()
	close.text = tr("SHOP_CLOSE")
	close.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
	close.pressed.connect(func(): shop_close.emit())
	sbox.add_child(close)

	_menu_panel = PanelContainer.new()
	_menu_panel.visible = false
	root.add_child(_menu_panel)
	_menu_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	_menu_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_menu_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var menu_box := VBoxContainer.new()
	menu_box.custom_minimum_size = Vector2(700, 0)
	_menu_panel.add_child(menu_box)
	_menu_title = Label.new()
	_menu_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_box.add_child(_menu_title)
	_menu_list = VBoxContainer.new()
	menu_box.add_child(_menu_list)
	var menu_close := Button.new()
	menu_close.text = tr("MENU_CLOSE")
	menu_close.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
	menu_close.pressed.connect(func(): menu_closed.emit())
	menu_box.add_child(menu_close)

	_minimap = MinimapView.new()
	_minimap.custom_minimum_size = Vector2(170, 170)
	_minimap.size = Vector2(170, 170)
	root.add_child(_minimap)
	_minimap.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE, 0)
	_minimap.position.x -= 200 + 24 + 0
	_minimap.position.y += 10
	_region_label = Label.new()
	root.add_child(_region_label)
	_region_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_MINSIZE, 8)
	_map_panel = PanelContainer.new()
	_map_panel.visible = false
	root.add_child(_map_panel)
	_map_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	_map_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_map_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var mbox := HBoxContainer.new()
	_map_panel.add_child(mbox)
	_map_big = MinimapView.new()
	_map_big.custom_minimum_size = Vector2(520, 520)
	mbox.add_child(_map_big)
	_map_info = Label.new()
	_map_info.custom_minimum_size = Vector2(360, 0)
	_map_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mbox.add_child(_map_info)

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


## Menggambar ulang kisi tas: tiap slot satu tombol; slot berisi item yang bisa dipakai
## memancarkan bag_use. Ikon item menunggu aset C-00x. Baris: {item, text, usable}.
func set_bag_slots(rows: Array) -> void:
	for c in _bag_grid.get_children():
		c.queue_free()
	for r in rows:
		var b := Button.new()
		b.text = str(r["text"])
		b.custom_minimum_size = Vector2(150, 70)
		b.disabled = not bool(r["usable"])
		var item := str(r["item"])
		b.pressed.connect(func(): bag_use.emit(item))
		_bag_grid.add_child(b)


func set_weather_text(text: String) -> void:
	_weather_label.text = tr("HUD_WEATHER") + ": " + text


func set_vitality_text(text: String) -> void:
	_vitality_label.text = text


func dialog_visible() -> bool:
	return _dialog_panel.visible


## Menampilkan satu baris dialog; bila `choice_texts` tidak kosong, tampil sebagai tombol pilihan.
func show_dialog(text: String, choice_texts: Array) -> void:
	_dialog_panel.visible = true
	_dialog_label.text = text
	for c in _dialog_choices.get_children():
		c.queue_free()
	for i in choice_texts.size():
		var b := Button.new()
		b.text = str(choice_texts[i])
		b.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
		b.pressed.connect(func(): dialog_choice.emit(i))
		_dialog_choices.add_child(b)
	_dialog_next.visible = choice_texts.is_empty()


func hide_dialog() -> void:
	_dialog_panel.visible = false


func shop_visible() -> bool:
	return _shop_panel.visible


## Menampilkan toko. Baris: {item, text, enabled}. Tombol memancarkan shop_buy / shop_sell.
func show_shop(title: String, buy_rows: Array, sell_rows: Array) -> void:
	_shop_panel.visible = true
	_shop_title.text = title
	_fill_shop(_shop_buy, tr("SHOP_BUY"), buy_rows, func(item): shop_buy.emit(item))
	_fill_shop(_shop_sell, tr("SHOP_SELL"), sell_rows, func(item): shop_sell.emit(item))


func _fill_shop(box: VBoxContainer, header: String, rows: Array, on_press: Callable) -> void:
	for c in box.get_children():
		c.queue_free()
	var h := Label.new()
	h.text = header
	box.add_child(h)
	for r in rows:
		var b := Button.new()
		b.text = str(r["text"])
		b.disabled = not bool(r["enabled"])
		b.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
		var item := str(r["item"])
		b.pressed.connect(func(): on_press.call(item))
		box.add_child(b)


func hide_shop() -> void:
	_shop_panel.visible = false


func map_visible() -> bool:
	return _map_panel.visible


func toggle_map() -> void:
	_map_panel.visible = not _map_panel.visible


func set_region_name(text: String) -> void:
	_region_label.text = text


func set_map_info(text: String) -> void:
	_map_info.text = text


func update_map(size: float, color: Color, player: Vector2, facing: Vector2, markers: Array) -> void:
	_minimap.set_data(size, color, player, facing, markers)
	if _map_panel.visible:
		_map_big.set_data(size, color, player, facing, markers)


func menu_visible() -> bool:
	return _menu_panel.visible


## Menu daftar serbaguna (stasiun crafting, papan quest, dsb). Baris: {id, text, enabled}.
func show_menu(title: String, rows: Array) -> void:
	_menu_panel.visible = true
	_menu_title.text = title
	for c in _menu_list.get_children():
		c.queue_free()
	for r in rows:
		var b := Button.new()
		b.text = str(r["text"])
		b.disabled = not bool(r["enabled"])
		b.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
		var id := str(r["id"])
		b.pressed.connect(func(): menu_pressed.emit(id))
		_menu_list.add_child(b)


func hide_menu() -> void:
	_menu_panel.visible = false
