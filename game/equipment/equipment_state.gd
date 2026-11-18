class_name EquipmentState
extends RefCounted
## Perlengkapan (D-058/D-013, SEMENTARA): slot senjata dan zirah. Item yang dipasang keluar dari
## Tas (tidak dihitung ganda); dilepas = kembali ke Tas. Bonus serangan/pertahanan dari data item.

const SAVE_VERSION := 1
const SLOTS := ["weapon", "armor"]

var _equipped: Dictionary = {}   # slot -> id item


func slot_item(slot: String) -> String:
	return str(_equipped.get(slot, ""))


func attack_bonus(item_defs: Dictionary) -> int:
	var w := slot_item("weapon")
	return int((item_defs.get(w, {}) as Dictionary).get("attack", 0)) if w != "" else 0


func defense_bonus(item_defs: Dictionary) -> int:
	var a := slot_item("armor")
	return int((item_defs.get(a, {}) as Dictionary).get("defense", 0)) if a != "" else 0


## Pasang item dari Tas; item lama (bila ada) kembali ke Tas. Semua-atau-tidak.
func equip(item_id: String, item_defs: Dictionary, inventory: Inventory) -> Dictionary:
	var slot := str((item_defs.get(item_id, {}) as Dictionary).get("slot", ""))
	if slot == "" or not SLOTS.has(slot):
		return {"ok": false, "reason": "not_equippable"}
	if not inventory.has(item_id):
		return {"ok": false, "reason": "no_item"}
	var old := slot_item(slot)
	inventory.remove(item_id, 1)
	if old != "":
		if not inventory.can_add(old, 1):
			inventory.add(item_id, 1)   # kembalikan; tas penuh
			return {"ok": false, "reason": "inventory_full"}
		inventory.add(old, 1)
	_equipped[slot] = item_id
	return {"ok": true, "reason": ""}


func unequip(slot: String, inventory: Inventory) -> Dictionary:
	var item := slot_item(slot)
	if item == "":
		return {"ok": false, "reason": "empty"}
	if not inventory.can_add(item, 1):
		return {"ok": false, "reason": "inventory_full"}
	inventory.add(item, 1)
	_equipped.erase(slot)
	return {"ok": true, "reason": ""}


func reset() -> void:
	_equipped.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "equipped": _equipped.duplicate()}


func from_dict(data: Dictionary, item_defs: Dictionary = {}) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("equipped", null)) != TYPE_DICTIONARY:
		return false
	var staged: Dictionary = {}
	for slot in data["equipped"]:
		var item := str(data["equipped"][slot])
		if not SLOTS.has(str(slot)) or str((item_defs.get(item, {}) as Dictionary).get("slot", "")) != str(slot):
			return false
		staged[str(slot)] = item
	_equipped = staged
	return true
