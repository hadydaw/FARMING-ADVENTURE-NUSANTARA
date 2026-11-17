class_name Crafting
extends RefCounted
## Crafting/memasak/meracik (D-020/D-026), logika murni. Resep dan bahan SEMENTARA (data uji).


static func recipes_for(station_id: String, recipes: Array) -> Array:
	var out: Array = []
	for r in recipes:
		if str(r["station"]) == station_id:
			out.append(r)
	return out


static func missing(recipe: Dictionary, inventory: Inventory) -> Array:
	var out: Array = []
	for i in recipe["inputs"]:
		if not inventory.has(str(i["item"]), int(i["count"])):
			out.append(str(i["item"]))
	return out


## Semua-atau-tidak: bahan dicek dulu, ruang untuk hasil dicek SETELAH bahan dikurangi,
## dan bila gagal bahan dikembalikan. Mengembalikan {ok, reason}.
static func craft(recipe: Dictionary, inventory: Inventory) -> Dictionary:
	if not missing(recipe, inventory).is_empty():
		return {"ok": false, "reason": "no_material"}
	var snapshot := inventory.to_dict()
	for i in recipe["inputs"]:
		inventory.remove(str(i["item"]), int(i["count"]))
	var out: Dictionary = recipe["output"]
	if not inventory.can_add(str(out["item"]), int(out["count"])):
		inventory.from_dict(snapshot)
		return {"ok": false, "reason": "inventory_full"}
	inventory.add(str(out["item"]), int(out["count"]))
	return {"ok": true, "reason": ""}
