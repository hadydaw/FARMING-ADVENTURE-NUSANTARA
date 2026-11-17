class_name GatherState
extends RefCounted
## Titik pengumpulan sumber daya (herbal, batu; D-028 "sumber daya"). Tumbuh lagi setelah
## beberapa hari permainan. Hari dari GameClock, bukan jam perangkat.

const SAVE_VERSION := 1

var _nodes: Dictionary = {}       # id -> row
var _last_gathered: Dictionary = {}  # id -> hari terakhir dikumpulkan


func _init(rows: Array) -> void:
	for r in rows:
		_nodes[str(r["id"])] = r


func has_node_id(id: String) -> bool:
	return _nodes.has(id)


func is_ready(id: String, day: int) -> bool:
	if not _nodes.has(id):
		return false
	if not _last_gathered.has(id):
		return true
	return day - int(_last_gathered[id]) >= int(_nodes[id]["respawn_days"])


## {ok, reason, item, count}. Gagal bila belum tumbuh lagi atau tas penuh (tidak menghabiskan titik).
func gather(id: String, day: int, inventory: Inventory) -> Dictionary:
	if not _nodes.has(id):
		return {"ok": false, "reason": "unknown", "item": "", "count": 0}
	if not is_ready(id, day):
		return {"ok": false, "reason": "not_ready", "item": "", "count": 0}
	var row: Dictionary = _nodes[id]
	if not inventory.can_add(str(row["item"]), int(row["count"])):
		return {"ok": false, "reason": "inventory_full", "item": "", "count": 0}
	inventory.add(str(row["item"]), int(row["count"]))
	_last_gathered[id] = day
	return {"ok": true, "reason": "", "item": str(row["item"]), "count": int(row["count"])}


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "last": _last_gathered.duplicate()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("last", null)) != TYPE_DICTIONARY:
		return false
	var staged := {}
	for k in data["last"]:
		var d := int(data["last"][k])
		if not _nodes.has(str(k)) or d < 0:
			return false
		staged[str(k)] = d
	_last_gathered = staged
	return true
