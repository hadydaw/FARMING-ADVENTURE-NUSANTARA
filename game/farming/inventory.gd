class_name Inventory
extends RefCounted
## Inventory berbasis slot (D-036: slot grid). Perilaku tumpukan dan batas masih
## terbuka di desain; jumlah slot dan batas tumpukan di sini bersumber dari data
## SEMENTARA. Logika murni, tanpa node.

signal changed

const SAVE_VERSION := 1

var slot_count: int
var _slots: Array = []        # tiap elemen {} (kosong) atau {"item": id, "count": n}
var _stack_max: Callable      # (item_id) -> int, 0 bila item tak dikenal


func _init(slots: int, stack_max_lookup: Callable) -> void:
	slot_count = slots
	_stack_max = stack_max_lookup
	for i in slots:
		_slots.append({})


func slots() -> Array:
	return _slots


func count(item_id: String) -> int:
	var total := 0
	for s in _slots:
		if not s.is_empty() and s["item"] == item_id:
			total += int(s["count"])
	return total


func has(item_id: String, amount: int = 1) -> bool:
	return count(item_id) >= amount


## Jumlah yang masih muat untuk item ini.
func free_space(item_id: String) -> int:
	var cap := int(_stack_max.call(item_id))
	if cap <= 0:
		return 0
	var space := 0
	for s in _slots:
		if s.is_empty():
			space += cap
		elif s["item"] == item_id:
			space += cap - int(s["count"])
	return space


func can_add(item_id: String, amount: int) -> bool:
	return amount > 0 and free_space(item_id) >= amount


## Menambah item; mengembalikan sisa yang TIDAK muat (0 = semua masuk).
func add(item_id: String, amount: int) -> int:
	var cap := int(_stack_max.call(item_id))
	if cap <= 0 or amount <= 0:
		return maxi(amount, 0)
	var remaining := amount
	for s in _slots:  # isi tumpukan yang ada dulu
		if remaining <= 0:
			break
		if not s.is_empty() and s["item"] == item_id and int(s["count"]) < cap:
			var put := mini(cap - int(s["count"]), remaining)
			s["count"] = int(s["count"]) + put
			remaining -= put
	for i in _slots.size():  # lalu slot kosong
		if remaining <= 0:
			break
		if _slots[i].is_empty():
			var put := mini(cap, remaining)
			_slots[i] = {"item": item_id, "count": put}
			remaining -= put
	if remaining != amount:
		changed.emit()
	return remaining


## Mengurangi item; semua-atau-tidak-sama-sekali. False bila jumlah tidak cukup.
func remove(item_id: String, amount: int) -> bool:
	if amount <= 0 or not has(item_id, amount):
		return false
	var remaining := amount
	for i in range(_slots.size() - 1, -1, -1):  # kosongkan dari slot belakang
		if remaining <= 0:
			break
		var s: Dictionary = _slots[i]
		if not s.is_empty() and s["item"] == item_id:
			var take := mini(int(s["count"]), remaining)
			s["count"] = int(s["count"]) - take
			remaining -= take
			if int(s["count"]) <= 0:
				_slots[i] = {}
	changed.emit()
	return true


func clear() -> void:
	for i in _slots.size():
		_slots[i] = {}
	changed.emit()


func to_dict() -> Dictionary:
	var out: Array = []
	for s in _slots:
		out.append({} if s.is_empty() else {"item": s["item"], "count": s["count"]})
	return {"v": SAVE_VERSION, "slots": out}


## Memuat dari save; semua-atau-tidak. False (tanpa mengubah apa pun) bila tidak valid.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("slots", null)) != TYPE_ARRAY:
		return false
	var incoming: Array = data["slots"]
	if incoming.size() != slot_count:
		return false
	var loaded: Array = []
	for entry in incoming:
		if typeof(entry) != TYPE_DICTIONARY:
			return false
		if (entry as Dictionary).is_empty():
			loaded.append({})
			continue
		var item := str(entry.get("item", ""))
		var n := int(entry.get("count", 0))
		var cap := int(_stack_max.call(item))
		if cap <= 0 or n <= 0 or n > cap:
			return false
		loaded.append({"item": item, "count": n})
	_slots = loaded
	changed.emit()
	return true
