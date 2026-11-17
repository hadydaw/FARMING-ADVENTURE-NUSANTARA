class_name DungeonState
extends RefCounted
## Dungeon dasar (D-016, SEMENTARA): ruangan dibangkitkan deterministik dari seed+hari+id,
## musuh dari kolam data, ruang terakhir bos. Tukar-serang per ketukan memakai rumus CombatState.
## Pingsan/keluar mengakhiri run; selesai memberi hadiah dan penutupan beberapa hari.

const SAVE_VERSION := 1

var rows: Dictionary = {}
var _monsters: Dictionary = {}
var run_id := ""            # kosong = tidak sedang berjalan
var room := 0
var enemy_hp := 0
var _rooms: Array = []      # id monster per ruangan
var _last_clear: Dictionary = {}   # id dungeon -> hari selesai


func _init(dungeon_rows: Array, monster_rows: Array) -> void:
	for d in dungeon_rows:
		rows[str(d["id"])] = d
	for m in monster_rows:
		_monsters[str(m["id"])] = m


func running() -> bool:
	return run_id != ""


func room_count() -> int:
	return _rooms.size()


func current_monster() -> Dictionary:
	if not running() or room >= _rooms.size():
		return {}
	return _monsters[_rooms[room]]


func is_boss_room() -> bool:
	return running() and room == _rooms.size() - 1


func available(id: String, day: int) -> bool:
	return rows.has(id) and (not _last_clear.has(id) or day - int(_last_clear[id]) >= int(rows[id]["cooldown_days"]))


func start(id: String, day: int, world_seed: int) -> Dictionary:
	if running():
		return {"ok": false, "reason": "running"}
	if not rows.has(id) or not available(id, day):
		return {"ok": false, "reason": "cooldown"}
	var d: Dictionary = rows[id]
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|%s|%d" % [world_seed, id, day])
	var pool: Array = d["pool"]
	_rooms = []
	for i in int(d["rooms"]) - 1:
		_rooms.append(str(pool[rng.randi() % pool.size()]))
	_rooms.append(str(d["boss"]))
	run_id = id
	room = 0
	enemy_hp = int(current_monster()["hp"])
	return {"ok": true, "reason": ""}


func leave() -> void:
	run_id = ""
	room = 0
	enemy_hp = 0
	_rooms = []


## {ok, reason, dealt, taken, room_cleared, cleared, fainted, exp, reward_money}
func attack(day: int, combat: CombatState, inventory: Inventory, item_defs: Dictionary, vitality: Vitality, economy: Economy, quests: QuestState) -> Dictionary:
	var res := {"ok": false, "reason": "", "dealt": 0, "taken": 0, "room_cleared": false, "cleared": false, "fainted": false, "exp": 0}
	if not running():
		res["reason"] = "not_running"
		return res
	if vitality.value("health") <= 0:
		res["reason"] = "no_health"
		return res
	if vitality.has_meter("stamina") and not vitality.spend("stamina", int(combat.config["stamina_cost"])):
		res["reason"] = "too_tired"
		return res
	var mon := current_monster()
	var dealt := maxi(1, combat.player_attack(inventory, item_defs) - int(mon["defense"]))
	res["ok"] = true
	res["dealt"] = dealt
	enemy_hp -= dealt
	if enemy_hp <= 0:
		res["room_cleared"] = true
		res["exp"] = int(mon["exp"])
		combat.exp_total += int(mon["exp"])
		for dr in mon["drops"]:
			if float(dr["chance"]) >= 1.0 and inventory.can_add(str(dr["item"]), int(dr["count"])):
				inventory.add(str(dr["item"]), int(dr["count"]))
		quests.on_defeat(str(mon["id"]))
		if is_boss_room():
			var rw: Dictionary = rows[run_id]["reward"]
			economy.add_money(int(rw["money"]))
			quests.points += int(rw["points"])
			_last_clear[run_id] = day
			res["cleared"] = true
			leave()
		else:
			room += 1
			enemy_hp = int(current_monster()["hp"])
		return res
	var taken := maxi(0, int(mon["attack"]) - combat.player_defense())
	res["taken"] = absi(vitality.change("health", -taken))
	if vitality.value("health") <= 0:
		res["fainted"] = true
		var loss := int(floor(float(economy.money) * float(combat.config["faint_money_loss"])))
		economy.money -= loss
		vitality.change("health", int(ceil(float(vitality.max_value("health")) * float(combat.config["faint_health_fraction"]))))
		leave()
	return res


func reset() -> void:
	leave()
	_last_clear.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "run": run_id, "room": room, "hp": enemy_hp, "rooms": _rooms.duplicate(), "clear": _last_clear.duplicate()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("rooms", null)) != TYPE_ARRAY or typeof(data.get("clear", null)) != TYPE_DICTIONARY:
		return false
	var run := str(data.get("run", ""))
	var rooms: Array = []
	for r in data["rooms"]:
		if not _monsters.has(str(r)):
			return false
		rooms.append(str(r))
	var clear: Dictionary = {}
	for k in data["clear"]:
		if not rows.has(str(k)):
			return false
		clear[str(k)] = int(data["clear"][k])
	if run != "":
		if not rows.has(run) or rooms.is_empty() or int(data.get("room", -1)) < 0 or int(data["room"]) >= rooms.size() or int(data.get("hp", 0)) <= 0:
			return false
	elif not rooms.is_empty():
		return false
	run_id = run
	room = int(data.get("room", 0))
	enemy_hp = int(data.get("hp", 0))
	_rooms = rooms
	_last_clear = clear
	return true
