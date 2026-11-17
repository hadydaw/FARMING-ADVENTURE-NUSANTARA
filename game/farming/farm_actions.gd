class_name FarmActions
extends RefCounted
## Aksi bertani kontekstual pada satu petak (cangkul/tanam/siram/panen), menggabungkan
## petak, inventory, dan musim. Skema kontrol (aksi otomatis menurut kondisi) bersifat
## SEMENTARA; pemilihan alat manual menunggu desain kontrol (D-034).

const TOOL_HOE := "tool_hoe"
const TOOL_WATERING_CAN := "tool_watering_can"


## Menentukan aksi yang akan dilakukan tanpa mengubah apa pun.
## Mengembalikan {action, reason, seed_item, crop}. action kosong bila tidak ada yang bisa dilakukan.
static func decide(plot: FarmPlot, inventory: Inventory, season_id: String, crop_defs: Dictionary) -> Dictionary:
	if plot.has_crop():
		if plot.is_ready(crop_defs):
			var def: Dictionary = crop_defs[plot.crop_id]
			if not inventory.can_add(str(def["harvest_item"]), int(def["harvest_amount"])):
				return _no("inventory_full")
			return {"action": "harvest", "reason": "", "seed_item": "", "crop": plot.crop_id}
		if plot.watered:
			return _no("already_watered")
		if not inventory.has(TOOL_WATERING_CAN):
			return _no("need_watering_can")
		return {"action": "water", "reason": "", "seed_item": "", "crop": plot.crop_id}
	if not plot.tilled:
		if not inventory.has(TOOL_HOE):
			return _no("need_hoe")
		return {"action": "till", "reason": "", "seed_item": "", "crop": ""}
	var any_seed := false
	for cid in crop_defs:
		var def: Dictionary = crop_defs[cid]
		if inventory.has(str(def["seed_item"])):
			any_seed = true
			if (def["seasons"] as Array).has(season_id):
				return {"action": "plant", "reason": "", "seed_item": str(def["seed_item"]), "crop": str(cid)}
	return _no("wrong_season" if any_seed else "need_seed")


## Melakukan aksi hasil decide(). Mengembalikan {ok, action, reason}.
static func perform(plot: FarmPlot, inventory: Inventory, season_id: String, crop_defs: Dictionary) -> Dictionary:
	var d := decide(plot, inventory, season_id, crop_defs)
	var action := str(d["action"])
	if action == "":
		return {"ok": false, "action": "", "reason": d["reason"]}
	var result: Dictionary
	match action:
		"till":
			result = plot.till()
		"plant":
			result = plot.plant(str(d["crop"]), season_id, crop_defs)
			if bool(result["ok"]):
				inventory.remove(str(d["seed_item"]), 1)
		"water":
			result = plot.water(crop_defs)
		"harvest":
			result = plot.harvest(crop_defs)
			if bool(result["ok"]):
				inventory.add(str(result["item"]), int(result["amount"]))
		_:
			result = {"ok": false, "reason": "unknown_action"}
	return {"ok": bool(result["ok"]), "action": action, "reason": str(result["reason"])}


static func _no(reason: String) -> Dictionary:
	return {"action": "", "reason": reason, "seed_item": "", "crop": ""}
