class_name ItemUse
extends RefCounted
## Memakai item konsumsi (D-057: pemulihan lewat makanan/ramuan). Efek SEMENTARA (data uji).


static func effects(item_def: Dictionary) -> Dictionary:
	return item_def.get("use", {})


## Tidak dipakai bila tak ada efek, atau semua meter yang dituju sudah penuh (cegah sia-sia).
static func use(item_id: String, item_defs: Dictionary, inventory: Inventory, vitality: Vitality) -> Dictionary:
	var def: Dictionary = item_defs.get(item_id, {})
	var eff := effects(def)
	if eff.is_empty():
		return {"ok": false, "reason": "not_usable"}
	if not inventory.has(item_id):
		return {"ok": false, "reason": "no_item"}
	var useful := false
	for meter in eff:
		if vitality.has_meter(str(meter)) and vitality.value(str(meter)) < vitality.max_value(str(meter)):
			useful = true
	if not useful:
		return {"ok": false, "reason": "already_full"}
	inventory.remove(item_id, 1)
	for meter in eff:
		vitality.change(str(meter), int(eff[meter]))
	return {"ok": true, "reason": ""}
