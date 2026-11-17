class_name LivestockState
extends RefCounted
## Kumpulan hewan ternak dan aksi pada satu hewan (beri pakan / ambil hasil).

const SAVE_VERSION := 1

var animals: Dictionary = {}   # id -> Animal
var species_defs: Dictionary = {}
var neglect_limit := 3


func _init(species_rows: Array, pens: Array, limit: int) -> void:
	neglect_limit = limit
	for s in species_rows:
		species_defs[str(s["id"])] = s
	for p in pens:
		animals[str(p["id"])] = Animal.new(str(p["id"]), str(p["species"]))


func advance_day() -> void:
	for a in animals.values():
		(a as Animal).advance_day(species_defs[(a as Animal).species], neglect_limit)


func def_of(animal_id: String) -> Dictionary:
	var a: Animal = animals.get(animal_id, null)
	return {} if a == null else species_defs[a.species]


## Aksi yang akan dilakukan tanpa mengubah apa pun: {action, reason}.
func decide(animal_id: String, inventory: Inventory) -> Dictionary:
	var a: Animal = animals.get(animal_id, null)
	if a == null:
		return {"action": "", "reason": "unknown_animal"}
	var def: Dictionary = species_defs[a.species]
	if a.is_ready(def):
		if not inventory.can_add(str(def["product_item"]), 1):
			return {"action": "", "reason": "inventory_full"}
		return {"action": "collect", "reason": ""}
	if a.fed:
		return {"action": "", "reason": "not_hungry"}
	if not inventory.has(str(def["feed_item"])):
		return {"action": "", "reason": "need_feed"}
	return {"action": "feed", "reason": ""}


func perform(animal_id: String, inventory: Inventory) -> Dictionary:
	var d := decide(animal_id, inventory)
	var action := str(d["action"])
	if action == "":
		return {"ok": false, "action": "", "reason": d["reason"]}
	var a: Animal = animals[animal_id]
	var def: Dictionary = species_defs[a.species]
	if action == "feed":
		inventory.remove(str(def["feed_item"]), 1)
		a.feed()
	else:
		a.collect(def)
		inventory.add(str(def["product_item"]), 1)
	return {"ok": true, "action": action, "reason": ""}


func to_dict() -> Dictionary:
	var out := {}
	for id in animals:
		out[id] = (animals[id] as Animal).to_dict()
	return {"v": SAVE_VERSION, "animals": out}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("animals", null)) != TYPE_DICTIONARY:
		return false
	var incoming: Dictionary = data["animals"]
	if incoming.size() != animals.size():
		return false
	var staged := {}
	for id in animals:
		if not incoming.has(id) or typeof(incoming[id]) != TYPE_DICTIONARY:
			return false
		var a := Animal.new(id, "")
		if not a.from_dict(incoming[id], species_defs):
			return false
		staged[id] = a
	animals = staged
	return true
