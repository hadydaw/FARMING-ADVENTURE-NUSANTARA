class_name UpgradeState
extends RefCounted
## Upgrade permanen (D-027 rumah/lahan, SEMENTARA): tambah slot tas, naikkan meter maksimum.
## Dibeli dengan uang + bahan (semua-atau-tidak). Efek dihitung dari himpunan upgrade yang dimiliki,
## sehingga simpan/muat hanya menyimpan daftar id (efek diterapkan ulang oleh FarmingSession).
## Belum: petak lahan baru / perluasan rumah (butuh node dunia; menunggu desain D-027).

const SAVE_VERSION := 1

var _rows: Dictionary = {}
var _order: Array = []
var _owned: Dictionary = {}


func _init(rows: Array) -> void:
	for r in rows:
		_rows[str(r["id"])] = r
		_order.append(str(r["id"]))


func ids() -> Array:
	return _order


func row(id: String) -> Dictionary:
	return _rows.get(id, {})


func owned(id: String) -> bool:
	return _owned.has(id)


## "owned" | "locked" | "available" | "" (tidak dikenal)
func status(id: String) -> String:
	if not _rows.has(id):
		return ""
	if _owned.has(id):
		return "owned"
	var req := str(_rows[id]["requires"])
	return "locked" if req != "" and not _owned.has(req) else "available"


func bonus_slots() -> int:
	var n := 0
	for id in _owned:
		var e: Dictionary = _rows[id]["effect"]
		if str(e["kind"]) == "bag_slots":
			n += int(e["amount"])
	return n


func meter_bonus(meter: String) -> int:
	var n := 0
	for id in _owned:
		var e: Dictionary = _rows[id]["effect"]
		if str(e["kind"]) == "max_meter" and str(e["meter"]) == meter:
			n += int(e["amount"])
	return n


## Pembelian semua-atau-tidak. {ok, reason}. Efek diterapkan oleh pemanggil (FarmingSession).
func buy(id: String, inventory: Inventory, economy: Economy) -> Dictionary:
	var st := status(id)
	if st == "":
		return {"ok": false, "reason": "unknown"}
	if st != "available":
		return {"ok": false, "reason": st}
	var r: Dictionary = _rows[id]
	if economy.money < int(r["cost"]):
		return {"ok": false, "reason": "no_money"}
	for m in r["materials"]:
		if not inventory.has(str(m["item"]), int(m["count"])):
			return {"ok": false, "reason": "no_material"}
	economy.money -= int(r["cost"])
	for m in r["materials"]:
		inventory.remove(str(m["item"]), int(m["count"]))
	_owned[id] = true
	return {"ok": true, "reason": ""}


func reset() -> void:
	_owned.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "owned": _owned.keys()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("owned", null)) != TYPE_ARRAY:
		return false
	var o: Dictionary = {}
	for id in data["owned"]:
		if not _rows.has(str(id)):
			return false
		o[str(id)] = true
	for id in o:   # syarat harus ikut dimiliki
		var req := str(_rows[id]["requires"])
		if req != "" and not o.has(req):
			return false
	_owned = o
	return true
