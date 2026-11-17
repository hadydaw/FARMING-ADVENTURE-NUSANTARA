extends Node3D
## Uji Fondasi (diagnostik): layar teknis untuk memeriksa di HP bahwa render 3D,
## landscape, area aman, sentuhan multi-touch (joystick + tombol), dan bahasa
## bekerja. BUKAN gameplay dan BUKAN aset final; mesh sederhana hanya penanda render.

var _info: Label
var _status: Label
var _joystick: TouchJoystick
var _buttons: Array[ActionButton] = []
var _pivot: Node3D


func _ready() -> void:
	_build_render_check()
	_build_ui()


func _process(delta: float) -> void:
	_pivot.rotate_y(delta * 0.6)
	_info.text = info_text()
	_status.text = status_text()


func info_text() -> String:
	var window := DisplayServer.window_get_size()
	var viewport := get_viewport().get_visible_rect().size
	var m := GameDisplay.safe_margins()
	var app := AppInfo.build_info()
	return "\n".join([
		tr("MENU_VERSION") % app["version"],
		tr("FT_RENDERER") % app["renderer"],
		tr("FT_FPS") % Engine.get_frames_per_second(),
		tr("FT_SCREEN") % ["%dx%d" % [window.x, window.y], "%dx%d" % [viewport.x, viewport.y]],
		tr("FT_SAFE") % [m["left"], m["top"], m["right"], m["bottom"]],
		tr("FT_ORIENT") % GameDisplay.orientation_name(),
		tr("FT_LOCALE") % TranslationServer.get_locale(),
		tr("FT_TOUCH") % (tr("FT_YES") if DisplayServer.is_touchscreen_available() else tr("FT_NO")),
	])


func status_text() -> String:
	var move := InputService.move_vector()
	var active: Array[String] = []
	for action in ["interact", "action_primary", "action_secondary"]:
		if Input.is_action_pressed(action):
			active.append(action)
	return "%s\n%s" % [
		tr("FT_MOVE") % [move.x, move.y],
		tr("FT_ACTIONS") % (", ".join(active) if not active.is_empty() else tr("FT_NONE")),
	]


func _build_render_check() -> void:
	_pivot = Node3D.new()
	add_child(_pivot)
	var camera := Camera3D.new()
	camera.position = Vector3(0, 2.2, 5.0)
	camera.fov = 50.0
	add_child(camera)
	camera.look_at(Vector3(0, 0.6, 0))
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	add_child(sun)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.20, 0.30, 0.34)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.9, 0.95, 1.0)
	env.ambient_light_energy = 0.6
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)
	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.4, 1.4, 1.4)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.85, 0.62, 0.25)
	material.metallic_specular = 0.0
	material.roughness = 1.0
	box.material = material
	mesh_instance.mesh = box
	mesh_instance.position = Vector3(0, 0.7, 0)
	_pivot.add_child(mesh_instance)


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var safe := SafeAreaContainer.new()
	layer.add_child(safe)
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	safe.add_child(root)

	var top := VBoxContainer.new()
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(top)
	var title := Label.new()
	title.text = tr("FT_TITLE")
	top.add_child(title)
	var notice := Label.new()
	notice.text = tr("FT_NOTICE") + "\n" + tr("FT_RENDER_NOTE")
	top.add_child(notice)
	_info = Label.new()
	top.add_child(_info)
	_status = Label.new()
	top.add_child(_status)

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

	var interact := _make_button(&"interact", "ACT_INTERACT")
	root.add_child(interact)
	interact.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_KEEP_SIZE, 24)
	interact.position.y -= 150
	var primary := _make_button(&"action_primary", "ACT_PRIMARY")
	root.add_child(primary)
	primary.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_KEEP_SIZE, 24)
	primary.position.x -= 150
	_buttons = [interact, primary]


func _make_button(action: StringName, label_key: String) -> ActionButton:
	var button := ActionButton.new()
	button.action = action
	button.label_key = label_key
	button.size = Vector2.ONE * button.radius * 2.0
	return button
