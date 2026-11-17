class_name WorldStart
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
var social: SocialState
var dialog: DialogRunner
var npc_nodes: Dictionary = {}
var animal_nodes: Dictionary = {}
var cast: FishingCast = null
var map: MapState
var current_region := "region_village"
var _markers: Array = []   # {node, kind, region}
var _npc_targets: Dictionary = {}
var plot_nodes: Dictionary = {}  # id petak -> Node3D
var _inspect_count := 0
var _models: Dictionary = {}  # prop id -> PackedScene
var sites: WorldSites
var player_outfit_material: StandardMaterial3D
var player_skin_material: StandardMaterial3D


func _ready() -> void:
	sites = WorldSites.new()
	sites.w = self
	sites.name = "Sites"
	add_child(sites)
	_build_environment()
	_build_ground()
	_build_props()
	_build_player()
	_build_camera()
	_build_ui()
	_build_farm()
	_build_npcs()
	_build_regions()
	_register_village_markers()
	sites.build_all()
	Events.interaction_performed.connect(_on_interacted)
	if SaveService.pending_load_slot >= 0:
		var slot := SaveService.pending_load_slot
		SaveService.pending_load_slot = -1
		load_game.call_deferred(slot)


func _process(delta: float) -> void:
	sites._follow_companion(delta)
	sites.update_monsters(delta)
	_move_npcs(delta)
	_update_map()
	_update_fishing(delta)
	if farming != null and farming.sleep != null and farming.sleep.is_sleeping():
		player.set_physics_process(false)
		hud.show_message(tr("SLEEPING"), 0.5)
		if not farming.sleep.step():
			return
	rig.target_position = player.global_position + Vector3(0, 1.0, 0)
	player.camera_yaw_deg = rig.yaw_deg
	sensor.facing = player.facing
	hud.set_prompt(_prompt_text())


func _prompt_text() -> String:
	if sensor.current == null:
		return ""
	if dialog != null and dialog.is_active():
		return ""
	if hud.shop_visible() or hud.menu_visible():
		return ""
	if sensor.current.has_meta("station_id"):
		return tr("FARM_ACT_CRAFT") + ": " + tr(str(sensor.current.get_meta("label_key", "")))
	if sensor.current.has_meta("is_mirror"):
		return tr("FARM_ACT_MIRROR")
	if sensor.current.has_meta("is_camp"):
		return tr("FARM_ACT_CAMP")
	if sensor.current.has_meta("is_upgrade"):
		return tr("FARM_ACT_UPGRADE")
	if sensor.current.has_meta("dungeon_id"):
		return tr("FARM_ACT_DUNGEON")
	if sensor.current.has_meta("is_board"):
		return tr("FARM_ACT_BOARD")
	if sensor.current.has_meta("spawn_id"):
		return tr("FARM_ACT_ATTACK") + ": " + tr(str(sensor.current.get_meta("label_key", "")))
	if sensor.current.has_meta("gather_id"):
		return tr("FARM_ACT_GATHER") + ": " + tr(str(sensor.current.get_meta("label_key", "")))
	if sensor.current.has_meta("link_id"):
		return tr("FARM_ACT_TRAVEL") + ": " + tr(str(sensor.current.get_meta("label_key", "")))
	if sensor.current.has_meta("shop_id"):
		return tr("FARM_ACT_SHOP")
	if cast != null:
		return tr("FARM_ACT_FISH")
	if sensor.current.has_meta("spot_id"):
		return tr("FARM_ACT_FISH")
	if sensor.current.has_meta("animal_id"):
		return _animal_prompt(str(sensor.current.get_meta("animal_id")))
	if sensor.current.has_meta("npc_id"):
		return tr("INTERACT_TALK") + ": " + tr(str(sensor.current.get_meta("label_key", "")))
	if sensor.current.has_meta("is_bed"):
		return tr("FARM_ACT_SLEEP")
	if sensor.current.has_meta("plot_id"):
		return _plot_prompt(str(sensor.current.get_meta("plot_id")))
	return tr(sensor.current.resolved_prompt_key()) + ": " + tr(str(sensor.current.get_meta("label_key", "")))


func inspect_count() -> int:
	return _inspect_count


func _on_interacted(target: Node, _actor: Node) -> void:
	if dialog != null and dialog.is_active():
		return
	if hud.shop_visible() or hud.menu_visible():
		return
	if target.has_meta("station_id"):
		sites._open_station(str(target.get_meta("station_id")))
		return
	if target.has_meta("is_mirror"):
		sites._open_mirror()
		return
	if target.has_meta("is_camp"):
		sites._open_camp()
		return
	if target.has_meta("is_upgrade"):
		sites._open_upgrades()
		return
	if target.has_meta("dungeon_id"):
		sites._open_dungeon(str(target.get_meta("dungeon_id")))
		return
	if target.has_meta("is_board"):
		sites._open_board()
		return
	if target.has_meta("spawn_id"):
		sites._attack(str(target.get_meta("spawn_id")))
		return
	if target.has_meta("gather_id"):
		sites._gather(str(target.get_meta("gather_id")))
		return
	if target.has_meta("link_id"):
		travel(str(target.get_meta("link_id")))
		return
	if target.has_meta("shop_id") and cast == null:
		_open_shop(str(target.get_meta("shop_id")))
		return
	if cast != null:
		_reel()
		return
	if target.has_meta("spot_id"):
		_start_fishing(str(target.get_meta("spot_id")))
		return
	if target.has_meta("animal_id"):
		_on_animal_interacted(str(target.get_meta("animal_id")))
		return
	if target.has_meta("npc_id"):
		_start_dialog(str(target.get_meta("npc_id")))
		return
	if target.has_meta("is_bed"):
		if farming.sleep.begin():
			hud.show_message(tr("SLEEPING"), 0.5)
		return
	if target.has_meta("plot_id"):
		_on_plot_interacted(str(target.get_meta("plot_id")))
		return
	_inspect_count += 1
	hud.show_message(tr("WORLD_INSPECTED") % tr(str(target.get_meta("label_key", ""))))


func _build_environment() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
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
	world_env.name = "WorldEnvironment"
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
	player_outfit_material = material
	marker.mesh = capsule
	marker.position = Vector3(0, 0.75, 0)
	player.add_child(marker)
	var nose := MeshInstance3D.new()
	var nose_mesh := BoxMesh.new()
	nose_mesh.size = Vector3(0.12, 0.12, 0.3)
	var skin_material := StandardMaterial3D.new()
	skin_material.albedo_color = Color(0.95, 0.8, 0.65)
	player_skin_material = skin_material
	nose_mesh.material = skin_material
	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.26
	head_mesh.height = 0.52
	head_mesh.material = skin_material
	head.mesh = head_mesh
	head.position = Vector3(0, 1.62, 0)
	player.add_child(head)
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
	var cfg: Dictionary = DataRegistry.get_row("farm_config", "default")
	farming = FarmingSession.new(GameTime.clock, DataRegistry.rows("items"), DataRegistry.rows("crops"),
		_plot_ids(), cfg, DataRegistry.rows("weather_types"), DataRegistry.rows("weather_chances"),
		int(cfg.get("world_seed", 0)), DataRegistry.rows("vitality_meters"), DataRegistry.get_row("rest_config", "default"),
		{"fish_species": DataRegistry.rows("fish_species"), "fishing_config": DataRegistry.get_row("fishing_config", "default"),
		"animals": DataRegistry.rows("animals"), "livestock_config": DataRegistry.get_row("livestock_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"), "shops": DataRegistry.rows("shops"),
		"gather_nodes": DataRegistry.rows("gather_nodes"), "recipes": DataRegistry.rows("recipes"), "stations": DataRegistry.rows("crafting_stations"),
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"character_options": DataRegistry.rows("character_options"), "companions": DataRegistry.rows("companions"), "upgrades": DataRegistry.rows("upgrades"), "festivals": DataRegistry.rows("festivals"), "achievements": DataRegistry.rows("achievements"), "dungeons": DataRegistry.rows("dungeons"), "quests": DataRegistry.rows("quests"), "guild_config": DataRegistry.get_row("guild_config", "default")})
	farming.sleep.finished.connect(_on_woke_up)
	_build_bed()
	_build_pond()
	_build_pens()
	_build_shop()
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
	_announce_milestones()
	sites._update_companion_visual()
	_apply_character_look()
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
	hud.set_vitality_text(vitality_text())
	_refresh_animals()
	hud.set_inventory_text(inventory_text())
	hud.set_weather_text(tr(str(farming.weather_types.get(farming.weather_today(), {}).get("name_key", "WEATHER_CLEAR"))))
	_apply_weather_look(farming.is_raining_today())
	var lines: Array = []
	for sl in farming.inventory.slots():
		if (sl as Dictionary).is_empty():
			lines.append({"item": "", "text": "-", "usable": false})
		else:
			var def: Dictionary = farming.item_defs[sl["item"]]
			lines.append({"item": str(sl["item"]), "text": "%s\nx%d" % [tr(str(def["name_key"])), int(sl["count"])], "usable": not ItemUse.effects(def).is_empty()})
	hud.set_bag_slots(lines)


func inventory_text() -> String:
	var parts: Array[String] = []
	for s in farming.inventory.slots():
		if not (s as Dictionary).is_empty():
			parts.append("%s x%d" % [tr(str(farming.item_defs[s["item"]]["name_key"])), int(s["count"])])
	return tr("HUD_MONEY") + ": %d | " % farming.economy.money + tr("FARM_BAG") + ": " + (", ".join(parts) if not parts.is_empty() else "-")


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
func save_game(slot: int = SAVE_SLOT, quiet: bool = false) -> bool:
	var err := SaveService.save_slot(slot, {"v": 1, "time": GameTime.clock.to_dict(), "farming": farming.to_dict(), "social": social.to_dict(), "map": map.to_dict(), "player": _player_save()})
	if not quiet or err != OK:
		hud.show_message(tr("SAVE_OK") if err == OK else tr("SAVE_FAIL"))
	return err == OK


## Muat dari slot 0; semua-atau-tidak (waktu dan pertanian harus sama-sama valid).
func load_game(slot: int = SAVE_SLOT) -> bool:
	var data: Dictionary = SaveService.load_slot(slot)
	if data.is_empty() or typeof(data.get("time")) != TYPE_DICTIONARY or typeof(data.get("farming")) != TYPE_DICTIONARY or typeof(data.get("social")) != TYPE_DICTIONARY or typeof(data.get("map")) != TYPE_DICTIONARY or typeof(data.get("player")) != TYPE_DICTIONARY:
		hud.show_message(tr("LOAD_NONE"))
		return false
	var backup_time: Dictionary = GameTime.clock.to_dict()
	var backup_farm: Dictionary = farming.to_dict()
	var backup_social: Dictionary = social.to_dict()
	if not GameTime.clock.from_dict(data["time"]):
		hud.show_message(tr("LOAD_FAIL"))
		return false
	if not farming.from_dict(data["farming"]):
		GameTime.clock.from_dict(backup_time)
		farming.from_dict(backup_farm)
		hud.show_message(tr("LOAD_FAIL"))
		return false
	var backup_map: Dictionary = map.to_dict()
	var pl: Dictionary = data["player"]
	if not social.from_dict(data["social"]) or not map.from_dict(data["map"]) or DataRegistry.get_row("regions", str(pl.get("region", ""))).is_empty() or not map.is_known(str(pl.get("region", ""))):
		GameTime.clock.from_dict(backup_time)
		farming.from_dict(backup_farm)
		social.from_dict(backup_social)
		map.from_dict(backup_map)
		hud.show_message(tr("LOAD_FAIL"))
		return false
	_place_player(str(pl["region"]), float(pl.get("x", 0.0)), float(pl.get("z", 0.0)))
	refresh_farm_visuals()
	snap_npcs()
	hud.show_message(tr("LOAD_OK"))
	return true


func _apply_weather_look(raining: bool) -> void:
	# Tampilan cuaca SEMENTARA: hujan = langit dan cahaya lebih gelap (belum ada partikel/aset).
	var we := get_node_or_null("WorldEnvironment") as WorldEnvironment
	if we != null:
		we.environment.background_color = Color(0.45, 0.52, 0.60) if raining else Color(0.62, 0.78, 0.90)
	var sun := get_node_or_null("Sun") as DirectionalLight3D
	if sun != null:
		sun.light_energy = 0.6 if raining else 1.1


func vitality_text() -> String:
	var v := farming.vitality
	var parts: Array[String] = []
	for id in v.ids():
		parts.append("%s %d/%d" % [tr("VIT_" + str(id).to_upper()), v.value(id), v.max_value(id)])
	parts.append("%s %d (EXP %d)" % [tr("VIT_LEVEL"), farming.combat.level(), farming.combat.exp_total])
	return " | ".join(parts)


## Tempat tidur SEMENTARA (kotak berlabel); bukan aset rumah final.
func _build_bed() -> void:
	var node := Node3D.new()
	node.name = "Bed"
	node.position = Vector3(-6.0, 0.0, 4.0)
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.0, 0.4, 2.0)
	mesh.mesh = box
	mesh.position.y = 0.2
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.35, 0.65)
	mesh.material_override = mat
	node.add_child(mesh)
	var label := Label3D.new()
	label.text = "UJI: TEMPAT TIDUR"
	label.pixel_size = 0.005
	label.position = Vector3(0, 1.0, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "sleep"
	node.add_child(it)
	it.set_meta("is_bed", true)
	add_child(node)


func _on_woke_up() -> void:
	player.set_physics_process(true)
	refresh_farm_visuals()
	var saved_ok := save_game(SaveService.AUTOSAVE_SLOT, true)   # simpan otomatis setelah tidur
	hud.show_message(tr("WOKE_UP") + ("\n" + tr("AUTOSAVE_OK") if saved_ok else ""))


# --- NPC uji (jadwal + dialog; konten generik SEMENTARA, bukan NPC resmi) ---

func _build_npcs() -> void:
	var scfg: Dictionary = DataRegistry.get_row("social_config", "default")
	var ids: Array = []
	for n in DataRegistry.rows("npcs"):
		ids.append(str(n["id"]))
	social = SocialState.new(ids, int(scfg["friendship_max"]), int(scfg["friendship_start"]))
	dialog = DialogRunner.new(DataRegistry.rows("dialogs"), social)
	dialog.line_changed.connect(func(key, choices):
		hud.show_dialog(tr(key), choices.map(func(k): return tr(str(k)))))
	dialog.ended.connect(_on_dialog_ended)
	hud.dialog_next.connect(func(): dialog.advance(GameTime.clock.day_index()))
	hud.dialog_choice.connect(func(i): dialog.choose(i, GameTime.clock.day_index()))
	var holder := Node3D.new()
	holder.name = "Npcs"
	add_child(holder)
	for n in DataRegistry.rows("npcs"):
		var node := Node3D.new()
		node.name = str(n["id"])
		var mesh := MeshInstance3D.new()
		var cap := CapsuleMesh.new()
		cap.radius = 0.3
		cap.height = 1.6
		mesh.mesh = cap
		mesh.position.y = 0.8
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(str(n["color"]))
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.name = "Info"
		label.pixel_size = 0.005
		label.position = Vector3(0, 2.0, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "talk"
		node.add_child(it)
		it.set_meta("npc_id", str(n["id"]))
		it.set_meta("label_key", str(n["name_key"]))
		holder.add_child(node)
		npc_nodes[str(n["id"])] = node
	Events.hour_changed.connect(func(_h): _update_npc_targets())
	Events.day_changed.connect(func(_d): _update_npc_targets())
	snap_npcs()


func npc_state(npc_id: String) -> Dictionary:
	return ScheduleResolver.resolve(DataRegistry.get_row("npcs", npc_id), GameTime.clock.hour(), farming.is_raining_today())


func _location_pos(loc_id: String) -> Vector3:
	var l := DataRegistry.get_row("npc_locations", loc_id)
	return Vector3(float(l.get("x", 0.0)), 0.0, float(l.get("z", 0.0)))


func _update_npc_targets() -> void:
	for id in npc_nodes:
		var st := npc_state(id)
		_npc_targets[id] = _location_pos(str(st["location"]))
		(npc_nodes[id].get_node("Info") as Label3D).text = "UJI: %s (%s)" % [tr(str(DataRegistry.get_row("npcs", id)["name_key"])), tr("ACT_ACTIVITY_" + str(st["activity"]).to_upper())]


## Menaruh NPC langsung di posisi jadwal sekarang (awal permainan, setelah muat).
func snap_npcs() -> void:
	_update_npc_targets()
	for id in npc_nodes:
		(npc_nodes[id] as Node3D).position = _npc_targets[id]


func _move_npcs(delta: float) -> void:
	# Gerak lurus sederhana menuju lokasi jadwal; belum ada pencarian jalur (D-040 #6 menyusul).
	for id in npc_nodes:
		if dialog != null and dialog.is_active() and dialog.active_npc() == id:
			continue
		var node: Node3D = npc_nodes[id]
		var target: Vector3 = _npc_targets.get(id, node.position)
		node.position = node.position.move_toward(target, 2.5 * delta)


func _dialog_context() -> Dictionary:
	return {"hour": GameTime.clock.hour(), "weather": farming.weather_today(),
		"season": GameTime.clock.season_id(), "day": GameTime.clock.day_index()}


func _start_dialog(npc_id: String) -> void:
	if dialog.start(npc_id, _dialog_context()):
		GameTime.clock.pause("dialog")  # SEMENTARA: waktu berhenti saat dialog
		player.set_physics_process(false)


func _on_dialog_ended() -> void:
	hud.hide_dialog()
	GameTime.clock.resume("dialog")
	player.set_physics_process(true)
	refresh_farm_visuals()


# --- Memancing dan peternakan (SEMENTARA: penanda berlabel, data uji generik) ---

func _build_pond() -> void:
	for sp in DataRegistry.get_row("fishing_config", "default")["spots"]:
		var node := Node3D.new()
		node.name = str(sp["id"])
		node.position = Vector3(float(sp["x"]), 0.0, float(sp["z"]))
		var mesh := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 2.5
		cyl.bottom_radius = 2.5
		cyl.height = 0.05
		mesh.mesh = cyl
		mesh.position.y = 0.03
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.5, 0.8)
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.text = "UJI: KOLAM"
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.0, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "fish_spot"
		it.position = Vector3(-2.0, 0, 0)  # titik tepi kolam tempat pemain berdiri
		node.add_child(it)
		it.set_meta("spot_id", str(sp["id"]))
		add_child(node)


func _start_fishing(spot_id: String) -> void:
	var r := farming.begin_fishing(spot_id)
	if not bool(r["ok"]):
		var key: String = {"need_rod": "FARM_NO_NEED_ROD", "too_tired": "FARM_NO_TOO_TIRED", "no_fish": "FISH_NO_FISH", "inventory_full": "FARM_NO_INVENTORY_FULL", "sleeping": "FARM_NO_SLEEPING"}.get(str(r["reason"]), "FARM_NO_UNKNOWN_ACTION")
		hud.show_message(tr(key))
		return
	cast = r["cast"]
	hud.show_message(tr("FISH_WAITING"), 5.0)
	refresh_farm_visuals()


func _update_fishing(delta: float) -> void:
	if cast == null:
		return
	var before := cast.state
	cast.advance(delta)
	if cast.state != before:
		if cast.state == FishingCast.BITE:
			hud.show_message(tr("FISH_BITE"), 2.0)
		elif cast.state == FishingCast.ESCAPED:
			_end_cast()


func _reel() -> void:
	cast.reel()
	_end_cast()


func _end_cast() -> void:
	if cast.state == FishingCast.CAUGHT:
		farming.finish_fishing(cast)
		hud.show_message(tr("FISH_CAUGHT"))
	elif cast.failure == "early":
		hud.show_message(tr("FISH_TOO_EARLY"))
	else:
		hud.show_message(tr("FISH_ESCAPED"))
	cast = null
	refresh_farm_visuals()


func _build_pens() -> void:
	var holder := Node3D.new()
	holder.name = "Animals"
	add_child(holder)
	for pen in DataRegistry.get_row("livestock_config", "default")["pens"]:
		var def := DataRegistry.get_row("animals", str(pen["species"]))
		var node := Node3D.new()
		node.name = str(pen["id"])
		node.position = Vector3(float(pen["x"]), 0.0, float(pen["z"]))
		var mesh := MeshInstance3D.new()
		var sph := SphereMesh.new()
		sph.radius = 0.4
		sph.height = 0.8
		mesh.mesh = sph
		mesh.position.y = 0.4
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(str(def["color"]))
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.name = "Info"
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.1, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "animal"
		node.add_child(it)
		it.set_meta("animal_id", str(pen["id"]))
		holder.add_child(node)
		animal_nodes[str(pen["id"])] = node


func _animal_state_key(animal_id: String) -> String:
	var a: Animal = farming.livestock.animals[animal_id]
	var def: Dictionary = farming.livestock.def_of(animal_id)
	if a.is_ready(def):
		return "ANIMAL_STATE_READY"
	if not a.is_mature(def):
		return "ANIMAL_STATE_YOUNG"
	return "ANIMAL_STATE_FED" if a.fed else "ANIMAL_STATE_HUNGRY"


func _refresh_animals() -> void:
	for id in animal_nodes:
		var def: Dictionary = farming.livestock.def_of(id)
		var a: Animal = farming.livestock.animals[id]
		var key := _animal_state_key(id)
		if not a.is_ready(def) and not a.fed:
			key = "ANIMAL_STATE_HUNGRY" if a.is_mature(def) else "ANIMAL_STATE_YOUNG"
		(animal_nodes[id].get_node("Info") as Label3D).text = "UJI: %s (%s)" % [tr(str(def["name_key"])), tr(key)]


func _animal_prompt(animal_id: String) -> String:
	var d := farming.animal_preview(animal_id)
	if str(d["action"]) == "":
		return tr("FARM_NO_" + str(d["reason"]).to_upper())
	return tr("FARM_ACT_" + str(d["action"]).to_upper())


func _on_animal_interacted(animal_id: String) -> void:
	var r := farming.animal_act(animal_id)
	if bool(r["ok"]):
		hud.show_message(tr("FARM_DONE_" + str(r["action"]).to_upper()))
	else:
		hud.show_message(tr("FARM_NO_" + str(r["reason"]).to_upper()))
	refresh_farm_visuals()


# --- Toko uji (SEMENTARA: kios penanda, barang/harga generik) ---

var _open_shop_id := ""


func _build_shop() -> void:
	hud.bag_use.connect(sites._on_bag_use)
	for sh in DataRegistry.rows("shops"):
		var node := Node3D.new()
		node.name = str(sh["id"])
		node.position = Vector3(float(sh["x"]), 0.0, float(sh["z"]))
		var mesh := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1.8, 1.2, 1.0)
		mesh.mesh = box
		mesh.position.y = 0.6
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.85, 0.65, 0.25)
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.text = "UJI: " + tr(str(sh["name_key"]))
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.6, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "shop"
		node.add_child(it)
		it.set_meta("shop_id", str(sh["id"]))
		add_child(node)
	hud.shop_buy.connect(_on_shop_buy)
	hud.shop_sell.connect(_on_shop_sell)
	hud.shop_close.connect(_close_shop)


func _open_shop(shop_id: String) -> void:
	_open_shop_id = shop_id
	GameTime.clock.pause("shop")  # SEMENTARA: waktu berhenti saat belanja
	player.set_physics_process(false)
	_refresh_shop()


func _refresh_shop() -> void:
	var sh: Dictionary = farming.shops[_open_shop_id]
	var buy_rows: Array = []
	for item in sh["stock"]:
		var price := farming.economy.buy_price(str(item))
		buy_rows.append({"item": item, "text": "%s  %d" % [tr(str(farming.item_defs[item]["name_key"])), price], "enabled": farming.economy.money >= price})
	var sell_rows: Array = []
	var seen := {}
	for slot in farming.inventory.slots():
		if (slot as Dictionary).is_empty() or seen.has(slot["item"]):
			continue
		seen[slot["item"]] = true
		var item := str(slot["item"])
		var price := farming.economy.sell_price(item, GameTime.clock.season_id())
		if price > 0:
			sell_rows.append({"item": item, "text": "%s x%d  %d" % [tr(str(farming.item_defs[item]["name_key"])), farming.inventory.count(item), price], "enabled": true})
	hud.show_shop(tr(str(sh["name_key"])) + "   " + tr("HUD_MONEY") + ": %d" % farming.economy.money, buy_rows, sell_rows)
	refresh_farm_visuals()


func _on_shop_buy(item: String) -> void:
	var r := farming.shop_buy(_open_shop_id, item, 1)
	hud.show_message(tr("SHOP_BOUGHT") if bool(r["ok"]) else tr("SHOP_NO_" + str(r["reason"]).to_upper()))
	_refresh_shop()


func _on_shop_sell(item: String) -> void:
	var r := farming.shop_sell(item, 1)
	hud.show_message(tr("SHOP_SOLD") + " +%d" % int(r["total"]) if bool(r["ok"]) else tr("SHOP_NO_" + str(r["reason"]).to_upper()))
	_refresh_shop()


func _close_shop() -> void:
	hud.hide_shop()
	_open_shop_id = ""
	GameTime.clock.resume("shop")
	player.set_physics_process(true)


# --- Wilayah, peta, minimap (D-054/D-028/D-009 teknis; wilayah generik SEMENTARA) ---

func _regions() -> Array:
	return DataRegistry.rows("regions")


func _region_origin(region_id: String) -> Vector3:
	return Vector3(float(DataRegistry.get_row("regions", region_id)["origin_x"]), 0.0, 0.0)


func _build_regions() -> void:
	var ids: Array = []
	for r in _regions():
		ids.append(str(r["id"]))
	map = MapState.new(ids, ["region_village"])
	var holder := Node3D.new()
	holder.name = "Regions"
	add_child(holder)
	for r in _regions():
		if not bool(r.get("generated", false)):
			continue
		var node := Node3D.new()
		node.name = str(r["id"])
		node.position = _region_origin(str(r["id"]))
		holder.add_child(node)
		_build_region_ground(node, float(r["size"]), Color(str(r["ground"])))
		var keep: Array = []
		for l in DataRegistry.rows("region_links"):
			if str(l["from"]) == str(r["id"]):
				keep.append(Vector2(float(l["x"]), float(l["z"])))
			if str(l["to"]) == str(r["id"]):
				keep.append(Vector2(float(l["to_x"]), float(l["to_z"])))
		for row in RegionLayout.generate(int(r["seed"]), float(r["size"]), r["props"], keep, 4.0):
			var def := DataRegistry.get_row("world_props", str(row["prop"]))
			var pn := _make_prop(def, row)
			if pn != null:
				node.add_child(pn)
	for l in DataRegistry.rows("region_links"):
		_build_portal(l)


func _build_region_ground(parent: Node3D, size_m: float, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = "Ground"
	var mi := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(size_m, size_m)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 1.0
	plane.material = mat
	mi.mesh = plane
	body.add_child(mi)
	var cs := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(size_m, 0.2, size_m)
	cs.shape = box
	cs.position = Vector3(0, -0.1, 0)
	body.add_child(cs)
	parent.add_child(body)
	var half := size_m / 2.0
	for side in [Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, 1), Vector3(0, 0, -1)]:
		var wall := StaticBody3D.new()
		wall.name = "Boundary"
		var ws := CollisionShape3D.new()
		var wb := BoxShape3D.new()
		wb.size = Vector3(size_m if side.x == 0 else 1.0, 4.0, 1.0 if side.x == 0 else size_m)
		ws.shape = wb
		wall.position = side * (half + 0.5) + Vector3(0, 2, 0)
		wall.add_child(ws)
		parent.add_child(wall)


func _build_portal(link: Dictionary) -> void:
	var node := Node3D.new()
	node.name = str(link["id"])
	node.position = _region_origin(str(link["from"])) + Vector3(float(link["x"]), 0.0, float(link["z"]))
	var mesh := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.35
	cyl.bottom_radius = 0.35
	cyl.height = 2.4
	mesh.mesh = cyl
	mesh.position.y = 1.2
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.75, 0.4, 0.95)
	mesh.material_override = mat
	node.add_child(mesh)
	var target_key := str(DataRegistry.get_row("regions", str(link["to"]))["name_key"])
	var label := Label3D.new()
	label.text = "UJI: GERBANG"
	label.pixel_size = 0.005
	label.position = Vector3(0, 2.8, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "travel"
	node.add_child(it)
	it.set_meta("link_id", str(link["id"]))
	it.set_meta("label_key", target_key)
	add_child(node)
	_markers.append({"node": node, "kind": "portal", "region": str(link["from"])})


func _register_village_markers() -> void:
	for sh in DataRegistry.rows("shops"):
		_markers.append({"node": get_node(str(sh["id"])), "kind": "shop", "region": "region_village"})
	_markers.append({"node": get_node("Bed"), "kind": "bed", "region": "region_village"})
	for sp in DataRegistry.get_row("fishing_config", "default")["spots"]:
		_markers.append({"node": get_node(str(sp["id"])), "kind": "pond", "region": "region_village"})
	for id in animal_nodes:
		_markers.append({"node": animal_nodes[id], "kind": "animal", "region": "region_village"})
	for id in npc_nodes:
		_markers.append({"node": npc_nodes[id], "kind": "npc", "region": "region_village"})


func _update_map() -> void:
	if map == null or player == null:
		return
	var rid := RegionRules.region_at(_regions(), player.global_position)
	if rid != "" and rid != current_region:
		current_region = rid
		map.discover(rid)
		var nm := tr(str(DataRegistry.get_row("regions", rid)["name_key"]))
		hud.show_message(tr("MAP_ENTERED") % nm)
	var region := DataRegistry.get_row("regions", current_region)
	var origin := _region_origin(current_region)
	var local := player.global_position - origin
	var list: Array = []
	for m in _markers:
		if str(m["region"]) == current_region and is_instance_valid(m["node"]):
			var lp: Vector3 = (m["node"] as Node3D).global_position - origin
			list.append({"pos": Vector2(lp.x, lp.z), "kind": m["kind"]})
	hud.set_region_name(tr(str(region["name_key"])))
	hud.update_map(float(region["size"]), Color(str(region["ground"])), Vector2(local.x, local.z), Vector2(player.facing.x, player.facing.z), list)
	if hud.map_visible():
		var lines: Array[String] = [tr("MAP_DISCOVERED") + ":"]
		for r in _regions():
			lines.append("- " + (tr(str(r["name_key"])) if map.is_known(str(r["id"])) else tr("MAP_UNKNOWN")))
		lines.append("")
		lines.append(tr("MAP_LEGEND"))
		hud.set_map_info("\n".join(lines))


func _player_save() -> Dictionary:
	var origin := _region_origin(current_region)
	var local := player.global_position - origin
	return {"region": current_region, "x": local.x, "z": local.z}


func _place_player(region_id: String, lx: float, lz: float) -> void:
	player.global_position = _region_origin(region_id) + Vector3(lx, 0.0, lz)
	player.velocity = Vector3.ZERO
	current_region = region_id
	rig.snap_to(player.global_position + Vector3(0, 1.0, 0))


## Berpindah lewat gerbang; wilayah terkunci menolak. Mengembalikan true bila pindah.
func travel(link_id: String) -> bool:
	var link := DataRegistry.get_row("region_links", link_id)
	if link.is_empty():
		return false
	var dest := DataRegistry.get_row("regions", str(link["to"]))
	if not RegionRules.is_unlocked(dest, GameTime.clock.day_index(), farming.inventory):
		hud.show_message(tr("MAP_LOCKED"))
		return false
	map.discover(str(link["to"]))
	_place_player(str(link["to"]), float(link["to_x"]), float(link["to_z"]))
	hud.show_message(tr("MAP_ENTERED") % tr(str(dest["name_key"])))
	return true


func _apply_character_look() -> void:
	if player_outfit_material == null or farming == null:
		return
	player_outfit_material.albedo_color = farming.character.color("outfit")
	player_skin_material.albedo_color = farming.character.color("skin")


func _announce_festival() -> void:
	var r := farming.claim_festival()
	if bool(r["ok"]):
		var nm := tr(str(r["event"]["name_key"]))
		hud.show_message((tr("FESTIVAL_TODAY") if bool(r["gift_given"]) else tr("FESTIVAL_BAG_FULL")) % nm)


func _announce_milestones() -> void:
	var fresh := farming.check_milestones()
	if fresh.is_empty():
		return
	var lines: Array[String] = []
	var hints_on := not GameSettings.has_setting("show_hints") or bool(GameSettings.get_value("show_hints"))
	for r in fresh:
		if str(r["kind"]) == "hint" and not hints_on:
			continue
		lines.append(tr(str(r["name_key"])))
	if lines.is_empty():
		return
	hud.show_message("\n".join(lines))


