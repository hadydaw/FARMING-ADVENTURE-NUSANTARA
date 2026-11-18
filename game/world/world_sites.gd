class_name WorldSites
extends Node
## Titik interaksi dunia uji (stasiun crafting, titik kumpul, monster, papan guild, gua,
## tukang upgrade, kemah teman). Dipisah dari world_start.gd agar berkas dunia tidak membengkak.
## Semua isi SEMENTARA (data uji generik). Dunia memegang HUD/sesi/pemain; kelas ini hanya
## membangun node dan menangani menu.

var w: WorldStart


func build_all() -> void:
	_build_stations()
	_build_gather_nodes()
	_build_monsters()
	_build_board()
	_build_upgrade_site()
	_build_camp()
	_build_mirror()
	_build_dungeon_entrance()


# --- Stasiun crafting, pengumpulan, pakai item (SEMENTARA) ---

var _open_station_id := ""
var gather_nodes: Dictionary = {}   # id -> Node3D


func _build_stations() -> void:
	for st in DataRegistry.rows("crafting_stations"):
		var node := Node3D.new()
		node.name = str(st["id"])
		node.position = Vector3(float(st["x"]), 0.0, float(st["z"]))
		var mesh := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(1.4, 1.0, 0.9)
		mesh.mesh = box
		mesh.position.y = 0.5
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(str(st["color"]))
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.text = "UJI: " + tr(str(st["name_key"]))
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.5, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "station"
		node.add_child(it)
		it.set_meta("station_id", str(st["id"]))
		it.set_meta("label_key", str(st["name_key"]))
		w.add_child(node)
	w.hud.menu_pressed.connect(_on_menu_pressed)
	w.hud.menu_closed.connect(_close_menu)


func _open_station(station_id: String) -> void:
	_open_station_id = station_id
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_station_menu()


func _recipe_text(r: Dictionary) -> String:
	var needs: Array[String] = []
	for i in r["inputs"]:
		needs.append("%s x%d" % [tr(str(w.farming.item_defs[i["item"]]["name_key"])), int(i["count"])])
	return "%s  (%s)" % [tr(str(r["name_key"])), ", ".join(needs)]


func _refresh_station_menu() -> void:
	var rows: Array = []
	for r in Crafting.recipes_for(_open_station_id, w.farming.recipes):
		rows.append({"id": str(r["id"]), "text": _recipe_text(r), "enabled": Crafting.missing(r, w.farming.inventory).is_empty()})
	var st := DataRegistry.get_row("crafting_stations", _open_station_id)
	w.hud.show_menu(tr(str(st["name_key"])), rows)
	w.refresh_farm_visuals()


func _on_menu_pressed(id: String) -> void:
	if _open_station_id == "__board__":
		_on_board_pressed(id)
		return
	if _open_station_id == "__mirror__":
		_on_mirror_pressed(id)
		return
	if _open_station_id == "__camp__":
		_on_camp_pressed(id)
		return
	if _open_station_id == "__upgrade__":
		_on_upgrade_pressed(id)
		return
	if _open_station_id == "__dungeon__":
		_on_dungeon_pressed(id)
		return
	if _open_station_id == "":
		return
	var r := w.farming.craft(id)
	w.hud.show_message(tr("CRAFT_DONE") if bool(r["ok"]) else tr("CRAFT_NO_" + str(r["reason"]).to_upper()))
	_refresh_station_menu()


func _close_menu() -> void:
	w.hud.hide_menu()
	_open_station_id = ""
	GameTime.clock.resume("menu")
	w.player.set_physics_process(true)


func _on_bag_use(item: String) -> void:
	if item.begins_with("__slot:"):
		var ru := w.farming.unequip_slot(item.substr(7))
		w.hud.show_message(tr("EQUIP_UNEQUIPPED") if bool(ru["ok"]) else tr("EQUIP_NO_" + str(ru["reason"]).to_upper()))
		w.refresh_farm_visuals()
		return
	var def: Dictionary = w.farming.item_defs.get(item, {})
	if def.has("slot"):
		var re := w.farming.equip_item(item)
		w.hud.show_message(tr("EQUIP_DONE") if bool(re["ok"]) else tr("EQUIP_NO_" + str(re["reason"]).to_upper()))
		w.refresh_farm_visuals()
		return
	var r := w.farming.use_item(item)
	w.hud.show_message(tr("USE_DONE") if bool(r["ok"]) else tr("USE_NO_" + str(r["reason"]).to_upper()))
	w.refresh_farm_visuals()


func _build_gather_nodes() -> void:
	for g in DataRegistry.rows("gather_nodes"):
		var node := Node3D.new()
		node.name = str(g["id"])
		node.position = w._region_origin(str(g["region"])) + Vector3(float(g["x"]), 0.0, float(g["z"]))
		var mesh := MeshInstance3D.new()
		var cone := CylinderMesh.new()
		cone.top_radius = 0.05
		cone.bottom_radius = 0.45
		cone.height = 0.7
		mesh.mesh = cone
		mesh.position.y = 0.35
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(str(g["color"]))
		mesh.material_override = mat
		mesh.name = "Mesh"
		node.add_child(mesh)
		var it := Interactable.new()
		it.interaction_type = "gather"
		node.add_child(it)
		it.set_meta("gather_id", str(g["id"]))
		it.set_meta("label_key", str(g["name_key"]))
		w.add_child(node)
		gather_nodes[str(g["id"])] = node
		w._markers.append({"node": node, "kind": "resource", "region": str(g["region"])})
	Events.day_changed.connect(func(_d): _refresh_gather_visuals())
	_refresh_gather_visuals()


func _refresh_gather_visuals() -> void:
	for id in gather_nodes:
		(gather_nodes[id].get_node("Mesh") as MeshInstance3D).visible = w.farming.gather.is_ready(id, GameTime.clock.day_index())


func _gather(node_id: String) -> void:
	var r := w.farming.gather_at(node_id)
	w.hud.show_message(tr("GATHER_DONE") + " +%d" % int(r["count"]) if bool(r["ok"]) else tr("GATHER_NO_" + str(r["reason"]).to_upper()))
	_refresh_gather_visuals()
	w.refresh_farm_visuals()


# --- Monster uji dan pertarungan dasar (SEMENTARA) ---

var monster_nodes: Dictionary = {}   # id spawn -> Node3D


func _build_monsters() -> void:
	for sp in DataRegistry.rows("monster_spawns"):
		var mon := DataRegistry.get_row("monsters", str(sp["monster"]))
		var node := Node3D.new()
		node.name = str(sp["id"])
		node.position = w._region_origin(str(sp["region"])) + Vector3(float(sp["x"]), 0.0, float(sp["z"]))
		var mesh := MeshInstance3D.new()
		var sphere := SphereMesh.new()
		sphere.radius = 0.6
		sphere.height = 1.2
		mesh.mesh = sphere
		mesh.position.y = 0.6
		mesh.name = "Mesh"
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(str(mon["color"]))
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.name = "Info"
		label.pixel_size = 0.005
		label.position = Vector3(0, 1.7, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "monster"
		node.add_child(it)
		it.set_meta("spawn_id", str(sp["id"]))
		it.set_meta("label_key", str(mon["name_key"]))
		w.add_child(node)
		node.set_meta("home", node.global_position)
		monster_nodes[str(sp["id"])] = node
		w._markers.append({"node": node, "kind": "monster", "region": str(sp["region"])})
	Events.day_changed.connect(func(_d): _refresh_monsters())
	Events.day_changed.connect(func(_d): w._announce_festival())
	_refresh_monsters()


func _refresh_monsters() -> void:
	var day := GameTime.clock.day_index()
	for id in monster_nodes:
		var node: Node3D = monster_nodes[id]
		var alive := w.farming.combat.is_alive(id, day)
		(node.get_node("Mesh") as MeshInstance3D).visible = alive
		var mon := w.farming.combat.spawn_monster(id)
		(node.get_node("Info") as Label3D).text = ("UJI: %s %d/%d" % [tr(str(mon["name_key"])), w.farming.combat.hp_of(id, day), int(mon["hp"])]) if alive else ""


func _attack(spawn_id: String) -> void:
	var r := w.farming.strike_monster(spawn_id)
	if not bool(r["ok"]):
		if str(r["reason"]) != "cooldown":
			w.hud.show_message(tr("COMBAT_NO_" + str(r["reason"]).to_upper()))
		return
	var msg := tr("COMBAT_HIT") % int(r["dealt"])
	if bool(r["defeated"]):
		msg = tr("COMBAT_DEFEATED") % int(r["exp"])
		for d in r["drops"]:
			msg += "\n%s: %s x%d" % [tr("COMBAT_DROP"), tr(str(w.farming.item_defs[d["item"]]["name_key"])), int(d["count"])]
		if bool(r["leveled"]):
			msg += "\n" + tr("COMBAT_LEVEL_UP")
	w.hud.show_message(msg, 1.2)
	_refresh_monsters()
	w.refresh_farm_visuals()


## Monster waktu-nyata: mengejar pemain dalam jarak kejar, menyerang berkala, kembali ke asal
## bila pemain jauh atau lewat batas kejar (lalu pulih). Berhenti saat menu/dialog/tidur (waktu dijeda).
func update_monsters(delta: float) -> void:
	if w.farming == null or w.player == null or monster_nodes.is_empty():
		return
	if GameTime.clock.is_paused() or w.hud.menu_visible() or w.hud.shop_visible():
		return
	var fc := w.farming
	fc.realtime.tick(delta)
	var day := GameTime.clock.day_index()
	var cfg: Dictionary = fc.realtime.cfg
	for id in monster_nodes:
		var node: Node3D = monster_nodes[id]
		if not fc.combat.is_alive(str(id), day):
			continue
		var home: Vector3 = node.get_meta("home")
		var to: Vector3 = w.player.global_position - node.global_position
		to.y = 0.0
		var dist := to.length()
		var away_from_home := node.global_position.distance_to(home)
		var decision := "idle" if away_from_home > float(cfg["leash"]) else fc.realtime.monster_decision(str(id), dist, delta)
		if decision == "chase":
			node.global_position += to.normalized() * float(cfg["monster_speed"]) * delta
		elif decision == "attack":
			var r := fc.monster_retaliate(str(id))
			if int(r["taken"]) > 0 or bool(r["fainted"]):
				if bool(r["fainted"]):
					w.hud.show_message(tr("COMBAT_FAINTED"))
					w._place_player("region_village", 0.0, 4.0)
				else:
					var extra := ""
					if str(r["inflict"]) != "":
						extra = "  " + tr("STATUS_INFLICTED") % tr(str(fc.status.row(str(r["inflict"]))["name_key"]))
					w.hud.show_message(tr("COMBAT_TAKEN") % int(r["taken"]) + extra, 1.0)
				_refresh_monsters()
				w.refresh_farm_visuals()
		elif decision == "idle" and away_from_home > 0.3:
			var back := home - node.global_position
			back.y = 0.0
			node.global_position += back.normalized() * minf(float(cfg["monster_speed"]) * delta, back.length())
			if node.global_position.distance_to(home) <= 0.3:
				fc.combat.heal_spawn(str(id))
				_refresh_monsters()


# --- Papan guild + quest (SEMENTARA) ---

func _build_board() -> void:
	var b: Dictionary = DataRegistry.get_row("guild_config", "default")["board"]
	var node := Node3D.new()
	node.name = "GuildBoard"
	node.position = Vector3(float(b["x"]), 0.0, float(b["z"]))
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.8, 1.6, 0.2)
	mesh.mesh = box
	mesh.position.y = 1.0
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.4, 0.2)
	mesh.material_override = mat
	node.add_child(mesh)
	var label := Label3D.new()
	label.text = "UJI: " + tr("BOARD_TITLE")
	label.pixel_size = 0.005
	label.position = Vector3(0, 2.2, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "board"
	node.add_child(it)
	it.set_meta("is_board", true)
	w.add_child(node)
	w._markers.append({"node": node, "kind": "shop", "region": "region_village"})


func _open_board() -> void:
	_open_station_id = "__board__"
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_board()


func _refresh_board() -> void:
	var rows: Array = []
	var q := w.farming.quests
	for id in q.ids():
		var st := q.status(str(id), w.farming.inventory)
		var def := q.quest(str(id))
		var prog := ""
		if st == "active" or st == "ready":
			prog = "  %d/%d" % [q.progress(str(id), w.farming.inventory), int(def["count"])]
		rows.append({"id": str(id), "text": "%s  [%s]%s" % [tr(str(def["name_key"])), tr("QUEST_STATE_" + st.to_upper()), prog], "enabled": st == "new" or st == "ready"})
	w.hud.show_menu("%s - %s" % [tr("BOARD_TITLE"), tr(str(q.cfg["ranks"][q.rank()]["name_key"]))], rows)


func _on_board_pressed(id: String) -> void:
	var q := w.farming.quests
	var r: Dictionary
	if q.status(id, w.farming.inventory) == "ready":
		r = w.farming.quest_turn_in(id)
		w.hud.show_message(tr("QUEST_COMPLETED") if bool(r["ok"]) else tr("QUEST_NO_" + str(r["reason"]).to_upper()))
	else:
		r = w.farming.quest_accept(id)
		w.hud.show_message(tr("QUEST_ACCEPTED") if bool(r["ok"]) else tr("QUEST_NO_" + str(r["reason"]).to_upper()))
	_refresh_board()
	w.refresh_farm_visuals()


# --- Gua/dungeon uji (SEMENTARA) ---

var _dungeon_id := ""


func _build_dungeon_entrance() -> void:
	for d in DataRegistry.rows("dungeons"):
		var node := Node3D.new()
		node.name = str(d["id"])
		node.position = w._region_origin(str(d["region"])) + Vector3(float(d["x"]), 0.0, float(d["z"]))
		var mesh := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 1.2
		cyl.bottom_radius = 1.6
		cyl.height = 1.6
		mesh.mesh = cyl
		mesh.position.y = 0.8
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.2, 0.3)
		mesh.material_override = mat
		node.add_child(mesh)
		var label := Label3D.new()
		label.text = "UJI: " + tr(str(d["name_key"]))
		label.pixel_size = 0.005
		label.position = Vector3(0, 2.2, 0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		node.add_child(label)
		var it := Interactable.new()
		it.interaction_type = "dungeon"
		node.add_child(it)
		it.set_meta("dungeon_id", str(d["id"]))
		w.add_child(node)
		w._markers.append({"node": node, "kind": "portal", "region": str(d["region"])})


func _open_dungeon(id: String) -> void:
	_dungeon_id = id
	_open_station_id = "__dungeon__"
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_dungeon()


func _refresh_dungeon() -> void:
	var dg := w.farming.dungeon
	var rows: Array = []
	var title := tr(str(dg.rows[_dungeon_id]["name_key"]))
	if dg.running():
		var mon := dg.current_monster()
		title += " - " + tr("DUNGEON_ROOM") % [dg.room + 1, dg.room_count()]
		if dg.is_boss_room():
			title += " (" + tr("DUNGEON_BOSS") + ")"
		rows.append({"id": "attack", "text": "%s: %s %d/%d" % [tr("DUNGEON_ATTACK"), tr(str(mon["name_key"])), dg.enemy_hp, int(mon["hp"])], "enabled": true})
		rows.append({"id": "leave", "text": tr("DUNGEON_FLEE"), "enabled": true})
	else:
		rows.append({"id": "start", "text": tr("DUNGEON_START"), "enabled": dg.available(_dungeon_id, GameTime.clock.day_index())})
	w.hud.show_menu(title, rows)
	w.refresh_farm_visuals()


func _on_dungeon_pressed(id: String) -> void:
	if id == "start":
		var r := w.farming.dungeon_start(_dungeon_id)
		if not bool(r["ok"]):
			w.hud.show_message(tr("DUNGEON_NO_" + str(r["reason"]).to_upper()))
	elif id == "leave":
		w.farming.dungeon.leave()
	elif id == "attack":
		var r := w.farming.dungeon_attack()
		if not bool(r["ok"]):
			w.hud.show_message(tr("DUNGEON_NO_" + str(r["reason"]).to_upper()))
		elif bool(r["fainted"]):
			w.hud.show_message(tr("DUNGEON_FAINTED"))
			_close_menu()
			w._place_player("region_village", 0.0, 4.0)
			return
		elif bool(r["cleared"]):
			w.hud.show_message(tr("DUNGEON_CLEARED"))
		elif bool(r["room_cleared"]):
			w.hud.show_message(tr("DUNGEON_ROOM_CLEAR"))
		else:
			w.hud.show_message(tr("COMBAT_HIT") % int(r["dealt"]) + "  " + tr("COMBAT_TAKEN") % int(r["taken"]))
	_refresh_dungeon()


# --- Tukang upgrade tas/meter (SEMENTARA) ---

func _build_upgrade_site() -> void:
	var cfg: Dictionary = DataRegistry.get_row("upgrade_config", "default")
	var node := Node3D.new()
	node.name = "UpgradeSite"
	node.position = Vector3(float(cfg["x"]), 0.0, float(cfg["z"]))
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.6, 1.2, 1.2)
	mesh.mesh = box
	mesh.position.y = 0.6
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.6, 0.65)
	mesh.material_override = mat
	node.add_child(mesh)
	var label := Label3D.new()
	label.text = "UJI: " + tr(str(cfg["name_key"]))
	label.pixel_size = 0.005
	label.position = Vector3(0, 1.8, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "upgrade"
	node.add_child(it)
	it.set_meta("is_upgrade", true)
	w.add_child(node)
	w._markers.append({"node": node, "kind": "shop", "region": "region_village"})


func _open_upgrades() -> void:
	_open_station_id = "__upgrade__"
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_upgrades()


func _refresh_upgrades() -> void:
	var up := w.farming.upgrades
	var rows: Array = []
	for id in up.ids():
		var st := up.status(str(id))
		var r := up.row(str(id))
		var needs: Array[String] = []
		for m in r["materials"]:
			needs.append("%s x%d" % [tr(str(w.farming.item_defs[m["item"]]["name_key"])), int(m["count"])])
		var tail := tr("UPGRADE_OWNED") if st == "owned" else (tr("UPGRADE_LOCKED") if st == "locked" else "%d + %s" % [int(r["cost"]), ", ".join(needs)])
		rows.append({"id": str(id), "text": "%s  [%s]" % [tr(str(r["name_key"])), tail], "enabled": st == "available"})
	w.hud.show_menu(tr("UPGRADE_SITE"), rows)
	w.refresh_farm_visuals()


func _on_upgrade_pressed(id: String) -> void:
	var r := w.farming.upgrade_buy(id)
	w.hud.show_message(tr("UPGRADE_DONE") if bool(r["ok"]) else tr("UPGRADE_NO_" + str(r["reason"]).to_upper()))
	_refresh_upgrades()


# --- Kemah teman + pengikut visual (SEMENTARA) ---

var companion_node: MeshInstance3D


func _build_camp() -> void:
	var cfg: Dictionary = DataRegistry.get_row("companion_config", "default")
	var node := Node3D.new()
	node.name = "CompanionCamp"
	node.position = Vector3(float(cfg["x"]), 0.0, float(cfg["z"]))
	var mesh := MeshInstance3D.new()
	var cone := CylinderMesh.new()
	cone.top_radius = 0.05
	cone.bottom_radius = 1.1
	cone.height = 1.6
	mesh.mesh = cone
	mesh.position.y = 0.8
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.85, 0.7, 0.4)
	mesh.material_override = mat
	node.add_child(mesh)
	var label := Label3D.new()
	label.text = "UJI: " + tr(str(cfg["name_key"]))
	label.pixel_size = 0.005
	label.position = Vector3(0, 2.2, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "camp"
	node.add_child(it)
	it.set_meta("is_camp", true)
	w.add_child(node)
	w._markers.append({"node": node, "kind": "npc", "region": "region_village"})
	companion_node = MeshInstance3D.new()
	var sph := SphereMesh.new()
	sph.radius = 0.35
	sph.height = 0.7
	companion_node.mesh = sph
	companion_node.material_override = StandardMaterial3D.new()
	companion_node.visible = false
	w.add_child(companion_node)


func _open_camp() -> void:
	_open_station_id = "__camp__"
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_camp()


func _refresh_camp() -> void:
	var cp := w.farming.companions
	var rows: Array = []
	for id in cp.ids():
		var r := cp.row(str(id))
		var tail := ""
		var enabled := true
		if not cp.owned(str(id)):
			tail = "%s %d" % [tr("COMPANION_RECRUIT"), int(r["cost"])]
		else:
			tail = tr("COMPANION_ACTIVE") if cp.active_id == str(id) else tr("COMPANION_READY")
		rows.append({"id": str(id), "text": "%s  [%s]  (ATK +%d, DEF +%d)" % [tr(str(r["name_key"])), tail, int(r["attack"]), int(r["guard"])], "enabled": enabled})
	w.hud.show_menu(tr("COMPANION_CAMP"), rows)
	_update_companion_visual()
	w.refresh_farm_visuals()


func _on_camp_pressed(id: String) -> void:
	var cp := w.farming.companions
	var r: Dictionary = cp.recruit(id, w.farming.economy) if not cp.owned(id) else w.farming.companion_toggle(id)
	w.hud.show_message(tr("COMPANION_DONE") if bool(r["ok"]) else tr("COMPANION_NO_" + str(r["reason"]).to_upper()))
	_refresh_camp()


func _update_companion_visual() -> void:
	if companion_node == null:
		return
	var id := w.farming.companions.active_id
	companion_node.visible = id != ""
	if id != "":
		(companion_node.material_override as StandardMaterial3D).albedo_color = Color(str(w.farming.companions.row(id)["color"]))
		if companion_node.position.distance_to(w.player.global_position) > 6.0:
			companion_node.global_position = w.player.global_position + Vector3(1.2, 0.4, 1.2)


func _follow_companion(delta: float) -> void:
	if companion_node == null or w.player == null or not companion_node.visible:
		return
	var target := w.player.global_position + Vector3(1.2, 0.5, 1.2)
	if companion_node.global_position.distance_to(target) > 8.0:
		companion_node.global_position = target   # pindah wilayah: langsung menyusul
	companion_node.global_position = companion_node.global_position.lerp(target, clampf(delta * 4.0, 0.0, 1.0))


# --- Cermin kustomisasi karakter (SEMENTARA) ---

func _build_mirror() -> void:
	var cfg: Dictionary = DataRegistry.get_row("character_config", "default")
	var node := Node3D.new()
	node.name = "Mirror"
	node.position = Vector3(float(cfg["x"]), 0.0, float(cfg["z"]))
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.0, 1.8, 0.15)
	mesh.mesh = box
	mesh.position.y = 0.9
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.7, 0.85, 0.95)
	mesh.material_override = mat
	node.add_child(mesh)
	var label := Label3D.new()
	label.text = "UJI: " + tr(str(cfg["name_key"]))
	label.pixel_size = 0.005
	label.position = Vector3(0, 2.3, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	node.add_child(label)
	var it := Interactable.new()
	it.interaction_type = "mirror"
	node.add_child(it)
	it.set_meta("is_mirror", true)
	w.add_child(node)
	w._markers.append({"node": node, "kind": "npc", "region": "region_village"})


func _open_mirror() -> void:
	_open_station_id = "__mirror__"
	GameTime.clock.pause("menu")
	w.player.set_physics_process(false)
	_refresh_mirror()


func _refresh_mirror() -> void:
	var rows: Array = []
	for g in w.farming.character.groups():
		var gid := str(g["id"])
		rows.append({"id": gid, "text": "%s: #%d / %d  (%s)" % [tr(str(g["label_key"])), w.farming.character.choice_index(gid) + 1, (g["choices"] as Array).size(), str(g["choices"][w.farming.character.choice_index(gid)])], "enabled": true})
	w.hud.show_menu(tr("CHAR_MIRROR"), rows)
	w.refresh_farm_visuals()


func _on_mirror_pressed(id: String) -> void:
	w.farming.character.cycle(id)
	_refresh_mirror()
