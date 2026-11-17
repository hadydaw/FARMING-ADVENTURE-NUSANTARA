class_name QuestState
extends RefCounted
## Quest dan peringkat guild dasar (D-037/D-017, SEMENTARA). Jenis: collect (item di tas, tidak
## dikonsumsi sampai diserahkan) dan defeat (hitung kalahkan SETELAH diterima). Hadiah semua-atau-tidak.

const SAVE_VERSION := 1

var cfg: Dictionary
var points := 0
var _quests: Dictionary = {}
var _active: Dictionary = {}    # id -> progres defeat
var _done: Dictionary = {}      # id -> true


func _init(rows: Array, guild_cfg: Dictionary) -> void:
	for q in rows:
		_quests[str(q["id"])] = q
	cfg = guild_cfg


func ids() -> Array:
	return _quests.keys()


func quest(id: String) -> Dictionary:
	return _quests.get(id, {})


func rank() -> int:
	var r := 0
	var ranks: Array = cfg["ranks"]
	for i in ranks.size():
		if points >= int(ranks[i]["points"]):
			r = i
	return r


## "locked" | "new" | "active" | "ready" | "done" | "" (tidak dikenal)
func status(id: String, inventory: Inventory) -> String:
	if not _quests.has(id):
		return ""
	if _done.has(id):
		return "done"
	if _active.has(id):
		return "ready" if progress(id, inventory) >= int(_quests[id]["count"]) else "active"
	return "locked" if rank() < int(_quests[id]["min_rank"]) else "new"


func progress(id: String, inventory: Inventory) -> int:
	if not _active.has(id):
		return 0
	var q: Dictionary = _quests[id]
	if str(q["type"]) == "collect":
		return mini(inventory.count(str(q["target"])), int(q["count"]))
	return mini(int(_active[id]), int(q["count"]))


func active_count() -> int:
	return _active.size()


func accept(id: String, inventory: Inventory) -> Dictionary:
	var st := status(id, inventory)
	if st == "":
		return {"ok": false, "reason": "unknown"}
	if st == "locked":
		return {"ok": false, "reason": "locked"}
	if st != "new":
		return {"ok": false, "reason": "taken"}
	if _active.size() >= int(cfg["max_active"]):
		return {"ok": false, "reason": "full"}
	_active[id] = 0
	return {"ok": true, "reason": ""}


func on_defeat(monster_id: String) -> void:
	for id in _active:
		var q: Dictionary = _quests[id]
		if str(q["type"]) == "defeat" and str(q["target"]) == monster_id:
			_active[id] = int(_active[id]) + 1


## Serahkan quest. Hadiah uang/EXP/poin/item semua-atau-tidak (tas penuh -> batal, tanpa efek).
func turn_in(id: String, inventory: Inventory, economy: Economy, combat: CombatState) -> Dictionary:
	if status(id, inventory) != "ready":
		return {"ok": false, "reason": "not_ready"}
	var q: Dictionary = _quests[id]
	var snapshot := inventory.to_dict()
	if str(q["type"]) == "collect":
		inventory.remove(str(q["target"]), int(q["count"]))
	var rw: Dictionary = q["reward"]
	for it in rw.get("items", []):
		if not inventory.can_add(str(it["item"]), int(it["count"])):
			inventory.from_dict(snapshot)
			return {"ok": false, "reason": "inventory_full"}
		inventory.add(str(it["item"]), int(it["count"]))
	economy.add_money(int(rw.get("money", 0)))
	combat.exp_total += int(rw.get("exp", 0))
	points += int(rw.get("points", 0))
	_active.erase(id)
	_done[id] = true
	return {"ok": true, "reason": ""}


func reset() -> void:
	points = 0
	_active.clear()
	_done.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "points": points, "active": _active.duplicate(), "done": _done.keys()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or int(data.get("points", -1)) < 0:
		return false
	if typeof(data.get("active", null)) != TYPE_DICTIONARY or typeof(data.get("done", null)) != TYPE_ARRAY:
		return false
	var active: Dictionary = {}
	for k in data["active"]:
		if not _quests.has(str(k)) or int(data["active"][k]) < 0:
			return false
		active[str(k)] = int(data["active"][k])
	var done: Dictionary = {}
	for k in data["done"]:
		if not _quests.has(str(k)) or active.has(str(k)):
			return false
		done[str(k)] = true
	if active.size() > int(cfg["max_active"]):
		return false
	points = int(data["points"])
	_active = active
	_done = done
	return true
