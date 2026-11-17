extends Control
## Menu utama (build uji). "Mulai (uji dunia awal)" membuka dunia uji teknis dengan aset
## SEMENTARA; bukan gameplay final. Pengaturan dan layar diagnostik berfungsi.

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var safe := SafeAreaContainer.new()
	add_child(safe)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 20)
	safe.add_child(column)

	var title := Label.new()
	title.text = tr("BOOT_TITLE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", roundi(UiTheme.BASE_FONT_SIZE * 2.0))
	column.add_child(title)

	var notice := Label.new()
	notice.text = tr("MENU_NOTICE")
	notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(notice)

	var latest := SaveService.latest_slot()
	if latest >= 0:
		var cont := _button("MENU_CONTINUE", func():
			SaveService.pending_load_slot = latest
			SceneManager.go("world_start"))
		cont.text = "%s (%s)" % [tr("MENU_CONTINUE"), tr("MENU_SLOT_AUTO") if latest == SaveService.AUTOSAVE_SLOT else tr("MENU_SLOT_MANUAL")]
		column.add_child(cont)
	column.add_child(_button("MENU_START_DEV", func():
		GameTime.new_game()
		SceneManager.go("world_start")))
	column.add_child(_button("MENU_SETTINGS", func(): SceneManager.go("settings")))
	column.add_child(_button("MENU_FOUNDATION_TEST", func(): SceneManager.go("foundation_test")))
	column.add_child(_button("MENU_SYSTEMS_TEST", func(): SceneManager.go("systems_test")))
	column.add_child(_button("MENU_MESH_PILOT", func(): SceneManager.go("mesh_pilot")))

	var version := Label.new()
	version.text = tr("MENU_VERSION") % AppInfo.version
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(version)


func _button(text_key: String, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = tr(text_key)
	button.custom_minimum_size = Vector2(420, UiTheme.MIN_TOUCH_HEIGHT)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(on_pressed)
	return button
