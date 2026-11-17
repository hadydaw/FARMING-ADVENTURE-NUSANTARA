class_name CompanionState
extends RefCounted
## Companion dasar (D-019, SEMENTARA): direkrut dengan uang, SATU yang aktif membantu bertarung
## (bonus serangan + penahan sebagian serangan balik). Tanpa AI/pertarungan sendiri, tanpa kepribadian.

const SAVE_VERSION := 1

var _rows: Dictionary = {}
var _order: Array = []
var _owned: Dictionary = {}
var active_id := ""


func _init(rows: Array) -> void:
	for r in rows:
		_rows[str(r["id"])] = r
		_order.append(str(r["id"]))


func ids() -> Array:
	return _order


func row(id: String) -> Dictionary:
	return _rows.get(id, {})


func owned(id: String) -> bool:
	return _owned.has(id)


func attack_bonus() -> int:
	return int(_rows[active_id]["attack"]) if active_id != "" else 0


func guard_bonus() -> int:
	return int(_rows[active_id]["guard"]) if active_id != "" else 0


func recruit(id: String, economy: Economy) -> Dictionary:
	if not _rows.has(id):
		return {"ok": false, "reason": "unknown"}
	if _owned.has(id):
		return {"ok": false, "reason": "owned"}
	if economy.money < int(_rows[id]["cost"]):
		return {"ok": false, "reason": "no_money"}
	economy.money -= int(_rows[id]["cost"])
	_owned[id] = true
	return {"ok": true, "reason": ""}


## Aktifkan (menggantikan yang lama) atau istirahatkan bila sudah aktif.
func toggle_active(id: String) -> Dictionary:
	if not _rows.has(id):
		return {"ok": false, "reason": "unknown"}
	if not _owned.has(id):
		return {"ok": false, "reason": "not_owned"}
	active_id = "" if active_id == id else id
	return {"ok": true, "reason": ""}


func reset() -> void:
	_owned.clear()
	active_id = ""


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "owned": _owned.keys(), "active": active_id}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("owned", null)) != TYPE_ARRAY:
		return false
	var o: Dictionary = {}
	for id in data["owned"]:
		if not _rows.has(str(id)):
			return false
		o[str(id)] = true
	var act := str(data.get("active", ""))
	if act != "" and not o.has(act):
		return false
	_owned = o
	active_id = act
	return true
