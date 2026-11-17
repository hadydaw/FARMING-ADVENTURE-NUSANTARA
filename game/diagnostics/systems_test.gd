extends Node3D
## Uji Sistem M2 (diagnostik): memeriksa di HP bahwa jam/kalender, kamera adaptif,
## gerak relatif kamera, dan pemilihan interaksi bekerja. BUKAN gameplay dan BUKAN
## aset final: balok dan bidang hanyalah penanda uji teknis berlabel.

const PROFILE_ORDER := ["farming", "exploration", "interaction"]
const MOVE_SPEED := 4.0

var rig: CameraRig
var sensor: InteractionSensor
var target: Node3D            # penanda posisi pemain (tak terlihat)
var _info: Label
var _joystick: TouchJoystick
var _profile_index := 0
var _interact_count := 0
var _last_interacted := ""
var _facing := Vector3(0, 0, -1)


func _ready() -> void:
	_build_world()
	_build_ui()
	Events.interaction_performed.connect(_on_interacted)


func _process(delta: float) -> void:
	var dir := MovementMath.camera_relative(InputService.move_vector(), rig.yaw_deg)
	target.global_position += dir * MOVE_SPEED * delta
	if dir.length_squared() > 0.0001:
		_facing = dir.normalized()
	sensor.facing = _facing
	rig.target_position = target.global_position
	_info.text = info_text()


func info_text() -> String:
	var c := GameTime.clock
	var lines: Array[String] = [tr("ST_TITLE")]
	lines.append(tr("ST_TIME") % [c.day_index() + 1, c.time_text(), c.year(), c.day_of_season()])
	lines.append(tr("ST_PHASE") % [tr("PHASE_" + c.phase_id().to_upper()), tr("SEASON_" + str(c.season_index() + 1))])
	if c.is_paused():
		lines.append(tr("ST_PAUSED") % ", ".join(c.pause_reasons()))
	lines.append(tr("ST_CAMERA") % [rig.profile_id, rig.zoom, rig.yaw_deg])
	var near := tr("ST_NO_TARGET")
	if sensor.current != null:
		near = tr(sensor.current.resolved_prompt_key()) + " [" + sensor.current.name + "]"
	lines.append(tr("ST_TARGET") % near)
	if _interact_count > 0:
		lines.append(tr("ST_INTERACTED") % [_last_interacted, _interact_count])
	return "\n".join(lines)


func _build_world() -> void:
	target = Node3D.new()
	add_child(target)
	rig = CameraRig.new()
	add_child(rig)
	rig.configure_from_registry()
	rig.target_position = target.global_position
	rig.set_profile("farming", true)
	rig.camera().current = true

	sensor = InteractionSensor.new()
	sensor.actor = target
	add_child(sensor)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -30, 0)
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

	# Bidang uji (penanda teknis).
	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(40, 40)
	plane.material = _material(Color(0.28, 0.38, 0.30))
	ground.mesh = plane
	add_child(ground)

	# Tiga penanda interaksi uji (bukan aset).
	for i in 3:
		var holder := Interactable.new()
		holder.name = "TestMarker%d" % (i + 1)
		holder.position = Vector3(-4.0 + i * 4.0, 0.0, -4.0)
		var mi := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1, 1, 1)
		box.material = _material(Color(0.85, 0.62, 0.25))
		mi.mesh = box
		mi.position = Vector3(0, 0.5, 0)
		holder.add_child(mi)
		add_child(holder)
		holder.interacted.connect(func(_a): _last_interacted = holder.name)


func _on_interacted(_t: Node, _a: Node) -> void:
	_interact_count += 1


func _material(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 1.0
	return m


func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var safe := SafeAreaContainer.new()
	layer.add_child(safe)
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	safe.add_child(root)

	_info = Label.new()
	_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info.custom_minimum_size = Vector2(760, 0)
	root.add_child(_info)

	var back := Button.new()
	back.text = tr("COMMON_BACK")
	back.size = Vector2(200, UiTheme.MIN_TOUCH_HEIGHT)
	root.add_child(back)
	back.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)
	back.pressed.connect(func(): SceneManager.back())

	var column := VBoxContainer.new()
	root.add_child(column)
	column.add_child(_tool_button("ST_BTN_PROFILE", _next_profile))
	column.add_child(_tool_button("ST_BTN_ROTATE", func(): rig.rotate_by(45.0)))
	column.add_child(_tool_button("ST_BTN_ZOOM", func(): rig.zoom = rig.zoom_min() if rig.zoom >= rig.zoom_max() - 0.001 else minf(rig.zoom + 0.2, rig.zoom_max())))
	column.add_child(_tool_button("ST_BTN_HOUR", func(): GameTime.clock.add_minutes(60)))
	column.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT, Control.PRESET_MODE_MINSIZE, 24)

	_joystick = TouchJoystick.new()
	_joystick.size = Vector2(380, 380)
	root.add_child(_joystick)
	_joystick.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT, Control.PRESET_MODE_KEEP_SIZE)

	var interact := ActionButton.new()
	interact.action = &"interact"
	interact.label_key = "ACT_INTERACT"
	interact.size = Vector2.ONE * interact.radius * 2.0
	root.add_child(interact)
	interact.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_KEEP_SIZE, 24)


func _next_profile() -> void:
	_profile_index = (_profile_index + 1) % PROFILE_ORDER.size()
	rig.set_profile(PROFILE_ORDER[_profile_index])


func _tool_button(key: String, on_pressed: Callable) -> Button:
	var b := Button.new()
	b.text = tr(key)
	b.custom_minimum_size = Vector2(240, UiTheme.MIN_TOUCH_HEIGHT)
	b.pressed.connect(on_pressed)
	return b
