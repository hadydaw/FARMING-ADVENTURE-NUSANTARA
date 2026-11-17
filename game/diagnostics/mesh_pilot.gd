extends Node3D
## Pilot mesh (Opsi A, O-010): menampilkan props B-003 hasil mesh lewat kode untuk
## EVALUASI VISUAL. BUKAN aset final dan BUKAN desain resmi (belum ada acuan ChatGPT).
## Tiang 1,6 m di sisi kiri hanyalah penanda skala diagnostik.

const SPACING := 4.0

var rig: CameraRig
var _index := 0
var _info: Label
var _items: Array[Node3D] = []


func _ready() -> void:
	_build_world()
	_build_ui()
	_focus(0, true)


func _process(_delta: float) -> void:
	_info.text = info_text()


func info_text() -> String:
	return "%s\n%s" % [tr("MP_TITLE"), tr("MP_CURRENT") % [PilotProps.PROP_IDS[_index], _tri_count(_items[_index])]]


func focus_index() -> int:
	return _index


func _tri_count(node: Node) -> int:
	var total := 0
	for child in node.find_children("*", "MeshInstance3D", true, false):
		var mesh := (child as MeshInstance3D).mesh
		if mesh != null:
			for s in mesh.get_surface_count():
				total += (mesh.surface_get_arrays(s)[Mesh.ARRAY_VERTEX] as PackedVector3Array).size() / 3
	return total


func _build_world() -> void:
	rig = CameraRig.new()
	add_child(rig)
	rig.configure_from_registry()
	rig.camera().current = true

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -35, 0)
	sun.light_energy = 1.1
	add_child(sun)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.62, 0.78, 0.90)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.85, 0.9, 1.0)
	env.ambient_light_energy = 0.7
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)

	var ground := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(80, 30)
	var gm := StandardMaterial3D.new()
	gm.albedo_color = Color(0.36, 0.5, 0.30)
	gm.roughness = 1.0
	plane.material = gm
	ground.mesh = plane
	add_child(ground)

	for i in PilotProps.PROP_IDS.size():
		var id: String = PilotProps.PROP_IDS[i]
		var scene := load("res://game/assets/models/pilot/pilot_%s.glb" % id) as PackedScene
		var node: Node3D
		if scene != null:
			node = scene.instantiate() as Node3D
		else:
			node = Node3D.new()
			push_error("MeshPilot: model pilot tidak termuat: " + id)
		node.name = id
		node.position = Vector3(float(i) * SPACING, 0, 0)
		add_child(node)
		_items.append(node)

	# Penanda skala 1,6 m (diagnostik).
	var pole := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.02
	cyl.bottom_radius = 0.02
	cyl.height = 1.6
	var pm := StandardMaterial3D.new()
	pm.albedo_color = Color(0.9, 0.2, 0.2)
	cyl.material = pm
	pole.mesh = cyl
	pole.position = Vector3(-2.0, 0.8, 1.5)
	add_child(pole)
	var label := Label3D.new()
	label.text = "1.6 m"
	label.pixel_size = 0.01
	label.position = Vector3(-2.0, 1.8, 1.5)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)


func _focus(i: int, instant: bool = false) -> void:
	_index = posmod(i, PilotProps.PROP_IDS.size())
	var box := _item_aabb(_items[_index])
	rig.target_position = _items[_index].position + Vector3(0, box.size.y * 0.5, 0)
	# Pilot saja: jarak mengikuti ukuran prop (di luar batas zoom bawaan; hanya diagnostik).
	rig.zoom = maxf(box.get_longest_axis_size() * 2.4 / 11.0, 0.06)
	rig.set_profile("exploration", instant)
	if instant:
		rig.step(1.0)


func _item_aabb(node: Node3D) -> AABB:
	var box := AABB()
	var first := true
	for child in node.find_children("*", "MeshInstance3D", true, false):
		var mi := child as MeshInstance3D
		if mi.mesh == null:
			continue
		var b := mi.mesh.get_aabb()
		box = b if first else box.merge(b)
		first = false
	return box


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

	var bar := HBoxContainer.new()
	root.add_child(bar)
	bar.add_child(_button("MP_PREV", func(): _focus(_index - 1)))
	bar.add_child(_button("MP_NEXT", func(): _focus(_index + 1)))
	bar.add_child(_button("ST_BTN_ROTATE", func(): rig.rotate_by(45.0)))
	bar.add_child(_button("ST_BTN_ZOOM", func(): rig.zoom = rig.zoom_min() if rig.zoom >= rig.zoom_max() - 0.001 else minf(rig.zoom + 0.2, rig.zoom_max())))
	bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE, Control.PRESET_MODE_MINSIZE, 16)


func _button(key: String, on_pressed: Callable) -> Button:
	var b := Button.new()
	b.text = tr(key)
	b.custom_minimum_size = Vector2(220, UiTheme.MIN_TOUCH_HEIGHT)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.pressed.connect(on_pressed)
	return b
