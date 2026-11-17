extends Node3D
## Dunia awal UJI TEKNIS (Milestone 2). Dibangun dari data (world_props.json dan
## world_start_layout.json). Tata letak dan props bersifat SEMENTARA: props memakai
## model pilot mesh-kode (bukan aset final, menunggu acuan ChatGPT B-003) dan pemain
## memakai penanda berlabel (menunggu B-001). Ini bukan desain dunia resmi.

const WORLD_SIZE := 60.0

var player: PlayerController
var rig: CameraRig
var sensor: InteractionSensor
var hud: BasicHud
var prop_count := 0
var farming: FarmingSession
var plot_nodes: Dictionary = {}  # id petak -> Node3D
var _inspect_count := 0
var _models: Dictionary = {}  # prop id -> PackedScene


func _ready() -> void:
	_build_environment()
	_build_ground()
	_build_props()
	_build_player()
	_build_camera()
	_build_ui()
	_build_farm()
	Events.interaction_performed.connect(_on_interacted)


func _process(_delta: float) -> void:
	rig.target_position = player.global_position + Vector3(0, 1.0, 0)
	player.camera_yaw_deg = rig.yaw_deg
	sensor.facing = player.facing
	hud.set_prompt(_prompt_text())


func _prompt_text() -> String:
	if sensor.current == null:
		return ""
	if sensor.current.has_meta("plot_id"):
		return _plot_prompt(str(sensor.current.get_meta("plot_id")))
	return tr(sensor.current.resolved_prompt_key()) + ": " + tr(str(sensor.current.get_meta("label_key", "")))


func inspect_count() -> int:
	return _inspect_count


func _on_interacted(target: Node, _actor: Node) -> void:
	if target.has_meta("plot_id"):
		_on_plot_interacted(str(target.get_meta("plot_id")))
		return
	_inspect_count += 1
	hud.show_message(tr("WORLD_INSPECTED") % tr(str(target.get_meta("label_key", ""))))


func _build_environment() -> void:
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


func _build_ground() -> void:
	var body := StaticBody3D.new()
	body.name = "Ground"
	var mesh_instance := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(WORLD_SIZE, WORLD_SIZE)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.36, 0.5, 0.30)  # sementara; tekstur B-002 belum ada
	material.roughness = 1.0
	plane.material = material
	mesh_instance.mesh = plane
	body.add_child(mesh_instance)
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(WORLD_SIZE, 0.2, WORLD_SIZE)
	shape.shape = box
	shape.position = Vector3(0, -0.1, 0)
	body.add_child(shape)
	add_child(body)
	# Dinding batas tak terlihat agar pemain tidak keluar dari dunia.
	var half := WORLD_SIZE / 2.0
	for side in [Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, -1)]:
		var wall := StaticBody3D.new()
		wall.name = "Boundary"
		var ws := CollisionShape3D.new()
		var wb := BoxShape3D.new()
		wb.size = Vector3(WORLD_SIZE if side.x == 0 else 1.0, 4.0, 1.0 if side.x == 0 else WORLD_SIZE)
		ws.shape = wb
		wall.position = side * (half + 0.5) + Vector3(0, 2, 0)
		wall.add_child(ws)
		add_child(wall)


func _build_props() -> void:
	var props := Node3D.new()
	props.name = "Props"
	add_child(props)
	for row in DataRegistry.rows("world_start_layout"):
		var def := DataRegistry.get_row("world_props", str(row["prop"]))
		if def.is_empty():
			push_error("WorldStart: prop tidak dikenal: %s" % row["prop"])
			continue
		var node := _make_prop(def, row)
		if node != null:
			props.add_child(node)
			prop_count += 1


func _make_prop(def: Dictionary, row: Dictionary) -> Node3D:
	var id := str(def["id"])
	if not _models.has(id):
		_models[id] = load(str(def["model"]))
	var scene := _models[id] as PackedScene
	if scene == null:
		push_error("WorldStart: model tidak termuat: %s" % def["model"])
		return null
	var root: Node3D
	var collision: Dictionary = def.get("collision", {})
	var shape_kind := str(collision.get("shape", "none"))
	if shape_kind == "none":
		root = Node3D.new()
	else:
		root = StaticBody3D.new()
	root.name = "%s_%s" % [id, row["id"]]
	root.position = Vector3(float(row["x"]), 0.0, float(row["z"]))
	root.rotation_degrees.y = float(row["yaw_deg"])
	var s := float(row.get("scale", 1.0))
	root.add_child(scene.instantiate())
	root.scale = Vector3.ONE * s
	if shape_kind != "none":
		var shape := CollisionShape3D.new()
		if shape_kind == "cylinder":
			var cyl := CylinderShape3D.new()
			cyl.radius = float(collision["radius"])
			cyl.height = float(collision["height"])
			shape.shape = cyl
			shape.position = Vector3(0, cyl.height / 2.0, 0)
		else:
			var size := collision["size"] as Array
			var box := BoxShape3D.new()
			box.size = Vector3(float(size[0]), float(size[1]), float(size[2]))
			shape.shape = box
			shape.position = Vector3(0, box.size.y / 2.0, 0)
		root.add_child(shape)
	var interaction := str(def.get("interaction", ""))
	if interaction != "":
		var it := Interactable.new()
		it.interaction_type = interaction
		root.add_child(it)
		it.set_meta("label_key", str(def["label_key"]))
	return root


func _build_player() -> void:
	player = PlayerController.new()
	player.name = "Player"
	player.position = Vector3.ZERO
	add_child(player)
	# PENANDA SEMENTARA, bukan karakter final (model pemain menunggu B-001 dari ChatGPT).
	var marker := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.3
	capsule.height = 1.5
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.9, 0.3, 0.7)
	capsule.material = material
	marker.mesh = capsule
	marker.position = Vector3(0, 0.75, 0)
	player.add_child(marker)
	var nose := MeshInstance3D.new()
	var nose_mesh := BoxMesh.new()
	nose_mesh.size = Vector3(0.12, 0.12, 0.3)
	nose_mesh.material = material
	nose.mesh = nose_mesh
	nose.position = Vector3(0, 1.0, -0.35)
	player.add_child(nose)
	var label := Label3D.new()
	label.text = "PLACEHOLDER PEMAIN"
	label.pixel_size = 0.006
	label.position = Vector3(0, 1.9, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	player.add_child(label)
	sensor = InteractionSensor.new()
	sensor.actor = player
	player.add_child(sensor)
	player.facing_changed.connect(func(_d): pass)


func _build_camera() -> void:
	rig = CameraRig.new()
	add_child(rig)
	rig.configure_from_registry()
	rig.target_position = player.global_position + Vector3(0, 1.0, 0)
	rig.set_profile("exploration", true)
	rig.camera().current = true


func _build_ui() -> void:
	hud = BasicHud.new()
	add_child(hud)


# --- Pertanian (Milestone 3, UJI TEKNIS: visual petak = kotak penanda sementara) ---

func _build_farm() -> void:
	farming = FarmingSession.new(GameTime.clock, DataRegistry.rows("items"), DataRegistry.rows("crops"),
		_plot_ids(), DataRegistry.get_row("farm_config", "default"))
	var holder := Node3D.new()
	holder.name = "FarmPlots"
	add_child(holder)
	for row in DataRegistry.rows("farm_plots"):
		var node := Node3D.new()
		node.name = str(row["id"])
		node.position = Vector3(float(row["x"]), 0.0, float(row["z"]))
		var mesh := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1.6, 0.06, 1.6)
		mesh.mesh = box
		mesh.position.y = 0.03
		mesh.material_override = StandardMaterial3D.new()
		node.add_child(mesh)
		var crop := MeshInstance3D.new()
		crop.name = "CropMarker"
		var cm := BoxMesh.new()
		cm.size = Vector3(0.3, 0.3, 0.3)
		crop.mesh = cm
		crop.material_override = StandardMaterial3D.new()
		node.add_child(crop)
		var label := Label3D.new()
		label.name = "Info"
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.3, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "farm_plot"
		node.add_child(it)
		it.set_meta("plot_id", str(row["id"]))
		holder.add_child(node)
		plot_nodes[str(row["id"])] = node
	Events.day_changed.connect(func(_d): refresh_farm_visuals())
	hud.save_pressed.connect(save_game)
	hud.load_pressed.connect(load_game)
	refresh_farm_visuals()


func _plot_ids() -> Array:
	var ids: Array = []
	for row in DataRegistry.rows("farm_plots"):
		ids.append(str(row["id"]))
	return ids


func refresh_farm_visuals() -> void:
	for pid in plot_nodes:
		var plot: FarmPlot = farming.grid.plot(pid)
		var node: Node3D = plot_nodes[pid]
		var soil := (node.get_child(0) as MeshInstance3D).material_override as StandardMaterial3D
		soil.albedo_color = Color(0.25, 0.16, 0.10) if plot.watered else (Color(0.40, 0.27, 0.16) if plot.tilled else Color(0.45, 0.55, 0.30))
		var marker := node.get_node("CropMarker") as MeshInstance3D
		marker.visible = plot.has_crop()
		if plot.has_crop():
			var def: Dictionary = farming.crop_defs[plot.crop_id]
			var total := (def["stage_days"] as Array).size()
			var grown := clampf(float(plot.stage) / float(total), 0.0, 1.0)
			marker.scale = Vector3.ONE * (0.4 + 2.2 * grown)
			marker.position.y = 0.06 + 0.15 * marker.scale.y
			(marker.material_override as StandardMaterial3D).albedo_color = Color(str(def["marker_color"]))
		var info := node.get_node("Info") as Label3D
		info.text = "UJI: " + (tr("FARM_STATE_READY") if plot.is_ready(farming.crop_defs) else (tr("FARM_STATE_GROWING") if plot.has_crop() else (tr("FARM_STATE_TILLED") if plot.tilled else tr("FARM_STATE_RAW"))))
	hud.set_inventory_text(inventory_text())
	var lines: Array = []
	for sl in farming.inventory.slots():
		lines.append("-" if (sl as Dictionary).is_empty() else "%s\nx%d" % [tr(str(farming.item_defs[sl["item"]]["name_key"])), int(sl["count"])])
	hud.set_bag_slots(lines)


func inventory_text() -> String:
	var parts: Array[String] = []
	for s in farming.inventory.slots():
		if not (s as Dictionary).is_empty():
			parts.append("%s x%d" % [tr(str(farming.item_defs[s["item"]]["name_key"])), int(s["count"])])
	return tr("FARM_BAG") + ": " + (", ".join(parts) if not parts.is_empty() else "-")


func _plot_prompt(plot_id: String) -> String:
	var d := farming.preview(plot_id)
	if str(d["action"]) == "":
		return tr("FARM_NO_" + str(d["reason"]).to_upper())
	return tr("FARM_ACT_" + str(d["action"]).to_upper())


func _on_plot_interacted(plot_id: String) -> void:
	var r := farming.act_on(plot_id)
	if bool(r["ok"]):
		hud.show_message(tr("FARM_DONE_" + str(r["action"]).to_upper()))
	else:
		hud.show_message(tr("FARM_NO_" + str(r["reason"]).to_upper()))
	refresh_farm_visuals()


const SAVE_SLOT := 0


## Simpan uji ke slot 0: waktu permainan + status pertanian (bukan jam perangkat).
func save_game() -> bool:
	var err := SaveService.save_slot(SAVE_SLOT, {"v": 1, "time": GameTime.clock.to_dict(), "farming": farming.to_dict()})
	hud.show_message(tr("SAVE_OK") if err == OK else tr("SAVE_FAIL"))
	return err == OK


## Muat dari slot 0; semua-atau-tidak (waktu dan pertanian harus sama-sama valid).
func load_game() -> bool:
	var data: Dictionary = SaveService.load_slot(SAVE_SLOT)
	if data.is_empty() or typeof(data.get("time")) != TYPE_DICTIONARY or typeof(data.get("farming")) != TYPE_DICTIONARY:
		hud.show_message(tr("LOAD_NONE"))
		return false
	var backup_time: Dictionary = GameTime.clock.to_dict()
	var backup_farm: Dictionary = farming.to_dict()
	if not GameTime.clock.from_dict(data["time"]):
		hud.show_message(tr("LOAD_FAIL"))
		return false
	if not farming.from_dict(data["farming"]):
		GameTime.clock.from_dict(backup_time)
		farming.from_dict(backup_farm)
		hud.show_message(tr("LOAD_FAIL"))
		return false
	refresh_farm_visuals()
	hud.show_message(tr("LOAD_OK"))
	return true
