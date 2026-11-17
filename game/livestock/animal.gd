class_name Animal
extends RefCounted
## Satu hewan ternak (D-024), logika murni: umur, diberi pakan hari ini, kemajuan
## produk, hari terlantar. Aturan SEMENTARA: hanya hari ber-pakan yang menambah umur
## dan kemajuan produk; terlantar berturut-turut melewati batas menahan produksi.

const SAVE_VERSION := 1

var id: String
var species: String
var age_days := 0
var fed := false
var progress := 0
var neglect := 0


func _init(animal_id: String = "", species_id: String = "") -> void:
	id = animal_id
	species = species_id


func is_mature(def: Dictionary) -> bool:
	return age_days >= int(def["mature_days"])


func is_ready(def: Dictionary) -> bool:
	return is_mature(def) and progress >= int(def["product_interval_days"])


func feed() -> bool:
	if fed:
		return false
	fed = true
	return true


func collect(def: Dictionary) -> bool:
	if not is_ready(def):
		return false
	progress = 0
	return true


## Pergantian hari: diberi pakan -> tumbuh/produksi (bila tidak terlalu lama terlantar).
func advance_day(def: Dictionary, neglect_limit: int) -> void:
	if fed:
		neglect = 0
		age_days += 1
		if is_mature(def) and not is_ready(def):
			progress += 1
	else:
		neglect += 1
		if neglect >= neglect_limit:
			progress = 0  # terlalu lama terlantar: kemajuan hilang
	fed = false


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "id": id, "species": species, "age": age_days, "fed": fed, "progress": progress, "neglect": neglect}


func from_dict(data: Dictionary, species_defs: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or not species_defs.has(str(data.get("species", ""))):
		return false
	if str(data.get("id", "")) != id:
		return false
	var a := int(data.get("age", -1))
	var p := int(data.get("progress", -1))
	var n := int(data.get("neglect", -1))
	if a < 0 or p < 0 or n < 0:
		return false
	species = str(data["species"])
	age_days = a
	fed = bool(data.get("fed", false))
	progress = p
	neglect = n
	return true
