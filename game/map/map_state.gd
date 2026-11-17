class_name MapState
extends RefCounted
## Wilayah yang sudah pernah dikunjungi/ditemukan (D-054: exploration discovery). Simpan/muat.

const SAVE_VERSION := 1

var _known: Dictionary = {}       # region id -> true
var _valid_ids: Array = []


func _init(region_ids: Array, start_ids: Array) -> void:
	_valid_ids = region_ids.duplicate()
	for id in start_ids:
		discover(str(id))


func discover(region_id: String) -> bool:
	if not _valid_ids.has(region_id) or _known.has(region_id):
		return false
	_known[region_id] = true
	return true


func is_known(region_id: String) -> bool:
	return _known.has(region_id)


func known_ids() -> Array:
	var out: Array = _known.keys()
	out.sort()
	return out


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "known": known_ids()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("known", null)) != TYPE_ARRAY:
		return false
	var staged := {}
	for id in data["known"]:
		if not _valid_ids.has(str(id)):
			return false
		staged[str(id)] = true
	_known = staged
	return true
