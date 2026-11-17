class_name AchievementState
extends RefCounted
## Pencapaian dan petunjuk tutorial (D-046/D-043, SEMENTARA). Tiap baris: statistik + ambang.
## Dibuka sekali (tersimpan) lalu dilaporkan sebagai "baru" tepat satu kali; "hint" tampil sekali.

const SAVE_VERSION := 1

var _rows: Array = []
var _known: Dictionary = {}
var _unlocked: Dictionary = {}


func _init(rows: Array) -> void:
	_rows = rows
	for r in rows:
		_known[str(r["id"])] = r


func is_unlocked(id: String) -> bool:
	return _unlocked.has(id)


func unlocked_count(kind: String) -> int:
	var n := 0
	for id in _unlocked:
		if str(_known[id]["kind"]) == kind:
			n += 1
	return n


## stats: {nama: int}. Mengembalikan baris yang baru terbuka (urut data).
func evaluate(stats: Dictionary) -> Array:
	var fresh: Array = []
	for r in _rows:
		var id := str(r["id"])
		if _unlocked.has(id):
			continue
		var stat := str(r["stat"])
		var ok := stat == "always" or (stats.has(stat) and int(stats[stat]) >= int(r["value"]))
		if ok:
			_unlocked[id] = true
			fresh.append(r)
	return fresh


func reset() -> void:
	_unlocked.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "unlocked": _unlocked.keys()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("unlocked", null)) != TYPE_ARRAY:
		return false
	var u: Dictionary = {}
	for id in data["unlocked"]:
		if not _known.has(str(id)):
			return false
		u[str(id)] = true
	_unlocked = u
	return true
