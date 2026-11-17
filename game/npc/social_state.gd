class_name SocialState
extends RefCounted
## Hubungan pemain-NPC (friendship) dan penanda dialog yang sudah dibicarakan
## (D-038 #8: hindari pengulangan). Skala SEMENTARA (D-039 belum menetapkan).

const SAVE_VERSION := 1

var friendship_max: int
var _friendship: Dictionary = {}   # npc id -> int
var _seen: Dictionary = {}         # dialog id -> hari terakhir dibicarakan


func _init(npc_ids: Array, max_value: int, start_value: int) -> void:
	friendship_max = max_value
	for id in npc_ids:
		_friendship[str(id)] = clampi(start_value, 0, max_value)


func friendship(npc_id: String) -> int:
	return int(_friendship.get(npc_id, 0))


func change_friendship(npc_id: String, delta: int) -> int:
	if not _friendship.has(npc_id):
		return 0
	var old := friendship(npc_id)
	_friendship[npc_id] = clampi(old + delta, 0, friendship_max)
	return friendship(npc_id) - old


func mark_seen(dialog_id: String, day: int) -> void:
	_seen[dialog_id] = day


func seen_on_day(dialog_id: String, day: int) -> bool:
	return int(_seen.get(dialog_id, -1)) == day


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "friendship": _friendship.duplicate(), "seen": _seen.duplicate()}


## Semua-atau-tidak: NPC harus persis sama; nilai dalam rentang; hari >= 0.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("friendship", null)) != TYPE_DICTIONARY or typeof(data.get("seen", null)) != TYPE_DICTIONARY:
		return false
	var fr: Dictionary = data["friendship"]
	if fr.size() != _friendship.size():
		return false
	var staged := {}
	for id in _friendship:
		if not fr.has(id):
			return false
		var v := int(fr[id])
		if v < 0 or v > friendship_max:
			return false
		staged[id] = v
	var seen := {}
	for k in data["seen"]:
		var d := int(data["seen"][k])
		if d < 0:
			return false
		seen[str(k)] = d
	_friendship = staged
	_seen = seen
	return true
