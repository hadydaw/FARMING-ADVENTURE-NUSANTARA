class_name StatusState
extends RefCounted
## Status efek dasar (D-059, SEMENTARA): racun/pemulihan berkala (dot) dan pengubah serangan.
## Waktu = menit game (GameClock), bukan jam perangkat. Racun tidak pernah mematikan (HP min 1).
## Menyegarkan efek yang sama memperpanjang durasinya, tidak menumpuk.

const SAVE_VERSION := 1

var _rows: Dictionary = {}
var _active: Dictionary = {}   # id -> {end, last}


func _init(rows: Array) -> void:
	for r in rows:
		_rows[str(r["id"])] = r


func row(id: String) -> Dictionary:
	return _rows.get(id, {})


func active_ids() -> Array:
	return _active.keys()


func is_active(id: String) -> bool:
	return _active.has(id)


func apply(id: String, now: int) -> bool:
	if not _rows.has(id):
		return false
	_active[id] = {"end": now + int(_rows[id]["duration"]), "last": now}
	return true


func clear(id: String) -> bool:
	return _active.erase(id)


func clear_all() -> void:
	_active.clear()


## Total pengubah serangan dari efek aktif.
func attack_mod() -> int:
	var n := 0
	for id in _active:
		if str(_rows[id]["kind"]) == "attack_mod":
			n += int(_rows[id]["amount"])
	return n


## Maju ke waktu 'now' (menit game): terapkan tik dot yang terlewat lalu buang yang habis.
## Mengembalikan jumlah efek yang berakhir pada pembaruan ini.
func update(now: int, vitality: Vitality) -> int:
	var expired := 0
	for id in _active.keys():
		var r: Dictionary = _rows[id]
		var st: Dictionary = _active[id]
		if str(r["kind"]) == "dot":
			var upto := mini(now, int(st["end"]))
			var ticks := (upto - int(st["last"])) / int(r["interval"])
			if ticks > 0:
				for i in ticks:
					var amt := int(r["amount"])
					if amt < 0:
						amt = -mini(-amt, maxi(vitality.value("health") - 1, 0))   # tidak mematikan
					vitality.change("health", amt)
				st["last"] = int(st["last"]) + ticks * int(r["interval"])
		if now >= int(st["end"]):
			_active.erase(id)
			expired += 1
	return expired


func reset() -> void:
	_active.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "active": _active.duplicate(true)}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("active", null)) != TYPE_DICTIONARY:
		return false
	var staged: Dictionary = {}
	for id in data["active"]:
		var st: Variant = data["active"][id]
		if not _rows.has(str(id)) or typeof(st) != TYPE_DICTIONARY or not st.has("end") or not st.has("last"):
			return false
		if int(st["last"]) > int(st["end"]):
			return false
		staged[str(id)] = {"end": int(st["end"]), "last": int(st["last"])}
	_active = staged
	return true
