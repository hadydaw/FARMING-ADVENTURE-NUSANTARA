class_name FarmPlot
extends RefCounted
## Satu petak lahan: kondisi tanah, tanaman, tahap tumbuh, penyiraman. Logika murni.
## Aturan (mis. tanaman layu, kualitas tanah, pupuk) masih terbuka di D-023; yang
## diimplementasikan hanya inti: olah, tanam, siram, tumbuh per hari, panen.

const SAVE_VERSION := 1

var id: String
var tilled: bool = false
var crop_id: String = ""
var stage: int = 0
var stage_days: int = 0
var watered: bool = false


func _init(plot_id: String = "") -> void:
	id = plot_id


func has_crop() -> bool:
	return crop_id != ""


## Siap panen bila tahap sudah melewati semua tahap tumbuh.
func is_ready(crop_defs: Dictionary) -> bool:
	return has_crop() and stage >= (crop_defs[crop_id]["stage_days"] as Array).size()


func till() -> Dictionary:
	if tilled:
		return _fail("already_tilled")
	tilled = true
	return _ok()


func plant(new_crop: String, season_id: String, crop_defs: Dictionary) -> Dictionary:
	if not crop_defs.has(new_crop):
		return _fail("unknown_crop")
	if not tilled:
		return _fail("not_tilled")
	if has_crop():
		return _fail("occupied")
	if not (crop_defs[new_crop]["seasons"] as Array).has(season_id):
		return _fail("wrong_season")
	crop_id = new_crop
	stage = 0
	stage_days = 0
	watered = false
	return _ok()


func water(crop_defs: Dictionary) -> Dictionary:
	if not has_crop():
		return _fail("no_crop")
	if is_ready(crop_defs):
		return _fail("already_ready")
	if watered:
		return _fail("already_watered")
	watered = true
	return _ok()


## Mengembalikan {ok, item, amount}; petak kembali kosong dan tetap tergemburkan.
func harvest(crop_defs: Dictionary) -> Dictionary:
	if not has_crop():
		return _fail("no_crop")
	if not is_ready(crop_defs):
		return _fail("not_ready")
	var def: Dictionary = crop_defs[crop_id]
	var result := {"ok": true, "reason": "", "item": str(def["harvest_item"]), "amount": int(def["harvest_amount"])}
	crop_id = ""
	stage = 0
	stage_days = 0
	watered = false
	return result


## Pergantian hari: tanaman tumbuh satu hari bila disiram (atau hujan), lalu penyiraman direset.
func advance_day(rained: bool, crop_defs: Dictionary) -> void:
	if has_crop() and not is_ready(crop_defs) and (watered or rained):
		stage_days += 1
		var lengths: Array = crop_defs[crop_id]["stage_days"]
		if stage_days >= int(lengths[stage]):
			stage += 1
			stage_days = 0
	watered = false


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "id": id, "tilled": tilled, "crop": crop_id, "stage": stage, "stage_days": stage_days, "watered": watered}


## Memuat dari save, memeriksa terhadap definisi tanaman. False bila tidak valid.
func from_dict(data: Dictionary, crop_defs: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	var c := str(data.get("crop", ""))
	var st := int(data.get("stage", 0))
	var sd := int(data.get("stage_days", 0))
	if c != "":
		if not crop_defs.has(c):
			return false
		var n := (crop_defs[c]["stage_days"] as Array).size()
		if st < 0 or st > n or sd < 0:
			return false
	elif st != 0 or sd != 0:
		return false
	tilled = bool(data.get("tilled", false))
	crop_id = c
	stage = st
	stage_days = sd
	watered = bool(data.get("watered", false))
	return true


func _ok() -> Dictionary:
	return {"ok": true, "reason": ""}


func _fail(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
