class_name Vitality
extends RefCounted
## Meter kondisi karakter (D-057): health, stamina, mana. Logika murni.
## Nilai maksimum/awal SEMENTARA (data uji). Konsumsi/regenerasi/penalti belum
## diputuskan; yang ada hanya mekanik meter dan pemulihan eksplisit.

signal changed(id: String)

const SAVE_VERSION := 1

var _max: Dictionary = {}
var _base_max: Dictionary = {}
var _value: Dictionary = {}


func _init(meter_rows: Array) -> void:
	for r in meter_rows:
		var id := str(r["id"])
		_max[id] = int(r["max"])
		_base_max[id] = int(r["max"])
		_value[id] = clampi(int(r["start"]), 0, int(r["max"]))


## Maksimum = dasar + bonus (upgrade); nilai sekarang dipangkas bila melebihi maksimum baru.
func set_max_bonus(id: String, bonus: int) -> void:
	if not _base_max.has(id):
		return
	_max[id] = int(_base_max[id]) + maxi(bonus, 0)
	_value[id] = mini(int(_value[id]), int(_max[id]))


func has_meter(id: String) -> bool:
	return _max.has(id)


func value(id: String) -> int:
	return int(_value.get(id, 0))


func max_value(id: String) -> int:
	return int(_max.get(id, 0))


func ids() -> Array:
	return _max.keys()


## Menambah/mengurangi dengan batas 0..max. Mengembalikan perubahan nyata (bisa 0).
func change(id: String, delta: int) -> int:
	if not has_meter(id):
		return 0
	var old := value(id)
	_value[id] = clampi(old + delta, 0, max_value(id))
	var actual := value(id) - old
	if actual != 0:
		changed.emit(id)
	return actual


func can_spend(id: String, amount: int) -> bool:
	return has_meter(id) and amount >= 0 and value(id) >= amount


## Mengeluarkan semua-atau-tidak. False bila tidak cukup.
func spend(id: String, amount: int) -> bool:
	if not can_spend(id, amount):
		return false
	change(id, -amount)
	return true


func restore_full(id: String) -> void:
	change(id, max_value(id))


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "values": _value.duplicate()}


## Semua-atau-tidak; ID meter harus persis sama dan nilai dalam rentang.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("values", null)) != TYPE_DICTIONARY:
		return false
	var incoming: Dictionary = data["values"]
	if incoming.size() != _max.size():
		return false
	var staged := {}
	for id in _max:
		if not incoming.has(id):
			return false
		var v := int(incoming[id])
		if v < 0 or v > int(_max[id]):
			return false
		staged[id] = v
	_value = staged
	for id in _max:
		changed.emit(id)
	return true
