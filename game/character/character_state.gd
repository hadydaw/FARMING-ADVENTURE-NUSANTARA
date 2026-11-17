class_name CharacterState
extends RefCounted
## Kustomisasi karakter dasar (D-041, SEMENTARA): pilihan warna dari data. Model karakter final
## (B-001) belum ada, jadi hanya mengubah warna penanda pemain. Pilihan tersimpan.
## Belum: nama (butuh input teks), gaya rambut/wajah/aksesori, pakaian terbuka lewat progres.

const SAVE_VERSION := 1

var _groups: Array = []
var _known: Dictionary = {}
var _choice: Dictionary = {}   # id grup -> indeks pilihan


func _init(rows: Array) -> void:
	_groups = rows
	for g in rows:
		_known[str(g["id"])] = g
		_choice[str(g["id"])] = 0


func groups() -> Array:
	return _groups


func choice_index(group_id: String) -> int:
	return int(_choice.get(group_id, 0))


func color(group_id: String) -> Color:
	if not _known.has(group_id):
		return Color.WHITE
	return Color(str(_known[group_id]["choices"][choice_index(group_id)]))


## Pilihan berikutnya (berputar). false bila grup tak dikenal.
func cycle(group_id: String) -> bool:
	if not _known.has(group_id):
		return false
	_choice[group_id] = (choice_index(group_id) + 1) % (_known[group_id]["choices"] as Array).size()
	return true


func set_choice(group_id: String, index: int) -> bool:
	if not _known.has(group_id) or index < 0 or index >= (_known[group_id]["choices"] as Array).size():
		return false
	_choice[group_id] = index
	return true


func reset() -> void:
	for id in _choice:
		_choice[id] = 0


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "choice": _choice.duplicate()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("choice", null)) != TYPE_DICTIONARY:
		return false
	var staged: Dictionary = {}
	for id in _known:
		var raw: Variant = data["choice"].get(id, 0)
		if typeof(raw) != TYPE_INT and typeof(raw) != TYPE_FLOAT:
			return false
		var i := int(raw)
		if i < 0 or i >= (_known[id]["choices"] as Array).size():
			return false
		staged[id] = i
	for id in data["choice"]:
		if not _known.has(str(id)):
			return false
	_choice = staged
	return true
