extends Control
## Layar Pengaturan (D-045). Dibangun otomatis dari skema data (GameSettings):
## kategori di kiri (landscape), daftar opsi di kanan. Hanya opsi yang benar-benar
## berfungsi yang ada di skema.

var _category := ""
var _rows_box: VBoxContainer
var _category_box: VBoxContainer
var _dialog: ConfirmationDialog


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var safe := SafeAreaContainer.new()
	add_child(safe)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	safe.add_child(root)

	var title := Label.new()
	title.text = tr("SET_TITLE")
	title.add_theme_font_size_override("font_size", roundi(UiTheme.BASE_FONT_SIZE * 1.5))
	root.add_child(title)

	var main := HBoxContainer.new()
	main.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main.add_theme_constant_override("separation", 20)
	root.add_child(main)

	_category_box = VBoxContainer.new()
	_category_box.custom_minimum_size = Vector2(260, 0)
	_category_box.add_theme_constant_override("separation", 10)
	main.add_child(_category_box)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main.add_child(scroll)
	_rows_box = VBoxContainer.new()
	_rows_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_rows_box.add_theme_constant_override("separation", 14)
	scroll.add_child(_rows_box)

	var bottom := HBoxContainer.new()
	root.add_child(bottom)
	bottom.add_child(_button("COMMON_BACK", func(): SceneManager.back()))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.add_child(spacer)
	bottom.add_child(_button("COMMON_RESET_ALL", _ask_reset))

	_dialog = ConfirmationDialog.new()
	_dialog.confirmed.connect(func():
		GameSettings.reset_all()
		_rebuild())
	add_child(_dialog)

	var categories := GameSettings.categories()
	_category = categories[0] if not categories.is_empty() else ""
	Events.language_changed.connect(func(_l): _rebuild())
	_rebuild()


func current_category() -> String:
	return _category


func select_category(category: String) -> void:
	_category = category
	_rebuild()


func _ask_reset() -> void:
	_dialog.dialog_text = tr("SET_RESET_CONFIRM")
	_dialog.ok_button_text = tr("SET_RESET_OK")
	_dialog.cancel_button_text = tr("SET_CANCEL")
	_dialog.popup_centered(Vector2i(720, 220))


func _rebuild() -> void:
	for child in _category_box.get_children():
		child.queue_free()
	for category in GameSettings.categories():
		var b := Button.new()
		b.text = tr("SET_CAT_" + category.to_upper())
		b.toggle_mode = true
		b.button_pressed = category == _category
		b.custom_minimum_size = Vector2(0, UiTheme.MIN_TOUCH_HEIGHT)
		b.pressed.connect(select_category.bind(category))
		_category_box.add_child(b)
	for child in _rows_box.get_children():
		child.queue_free()
	for row in GameSettings.rows_in(_category):
		_rows_box.add_child(_make_row(row))


func _make_row(row: Dictionary) -> Control:
	var id := str(row["id"])
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	var label := Label.new()
	label.text = tr(str(row["label_key"]))
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(label)
	match str(row["type"]):
		"enum":
			var option := OptionButton.new()
			option.custom_minimum_size = Vector2(320, UiTheme.MIN_TOUCH_HEIGHT)
			var options: Array = row["options"]
			for o in options:
				option.add_item(tr(str((row.get("option_keys", {}) as Dictionary).get(o, o))))
			option.select(options.find(GameSettings.get_value(id)))
			option.item_selected.connect(func(i): GameSettings.set_value(id, options[i]))
			box.add_child(option)
		"float":
			var slider := HSlider.new()
			slider.custom_minimum_size = Vector2(320, UiTheme.MIN_TOUCH_HEIGHT)
			slider.min_value = float(row["min"])
			slider.max_value = float(row["max"])
			slider.step = float(row.get("step", 0.01))
			slider.value = float(GameSettings.get_value(id))
			var value_label := Label.new()
			value_label.custom_minimum_size = Vector2(100, 0)
			value_label.text = format_value(row, slider.value)
			slider.value_changed.connect(func(v):
				GameSettings.set_value(id, v)
				value_label.text = format_value(row, float(GameSettings.get_value(id))))
			box.add_child(slider)
			box.add_child(value_label)
		"bool":
			var check := CheckButton.new()
			check.button_pressed = bool(GameSettings.get_value(id))
			check.toggled.connect(func(on): GameSettings.set_value(id, on))
			box.add_child(check)
	return box


static func format_value(row: Dictionary, value: float) -> String:
	match str(row.get("format", "")):
		"percent": return "%d%%" % roundi(value * 100.0)
		"multiplier": return "%.1f×" % value
	return "%.2f" % value


func _button(text_key: String, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = tr(text_key)
	button.custom_minimum_size = Vector2(260, UiTheme.MIN_TOUCH_HEIGHT)
	button.pressed.connect(on_pressed)
	return button
