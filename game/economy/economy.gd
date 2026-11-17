class_name Economy
extends RefCounted
## Uang, harga, jual-beli (D-021). Logika murni. Semua angka SEMENTARA (data uji).
## Harga jual = dasar x pengali musim x penurunan permintaan (tiap unit terjual hari ini
## menurunkan harga item itu; reset tiap hari). Tanpa jam perangkat.

const SAVE_VERSION := 1

var money: int
var _cfg: Dictionary
var _prices: Dictionary = {}     # item -> {buy, sell}
var _sold_today: Dictionary = {} # item -> jumlah


func _init(config: Dictionary, price_rows: Array) -> void:
	_cfg = config
	money = int(config["start_money"])
	for p in price_rows:
		_prices[str(p["item"])] = p


func advance_day() -> void:
	_sold_today.clear()


func buy_price(item: String) -> int:
	return int(_prices.get(item, {}).get("buy", 0))


func base_sell(item: String) -> int:
	return int(_prices.get(item, {}).get("sell", 0))


## Harga jual satu unit berikutnya (memperhitungkan musim dan unit yang sudah terjual hari ini).
func sell_price(item: String, season_id: String, already_sold: int = -1) -> int:
	var base := base_sell(item)
	if base <= 0:
		return 0
	var sold := int(_sold_today.get(item, 0)) if already_sold < 0 else already_sold
	var season_mult := float(_cfg["season_multiplier"].get(season_id, 1.0))
	var demand := maxf(float(_cfg["price_floor"]), 1.0 - float(_cfg["sold_drop"]) * float(sold))
	return maxi(int(floor(float(base) * season_mult * demand)), 1)


func add_money(amount: int) -> void:
	money = clampi(money + amount, 0, int(_cfg["max_money"]))


## Total harga menjual n unit sekarang (tanpa mengubah apa pun).
func quote_sell(item: String, n: int, season_id: String) -> int:
	var total := 0
	var sold := int(_sold_today.get(item, 0))
	for i in n:
		total += sell_price(item, season_id, sold + i)
	return total


func sell(inventory: Inventory, item: String, n: int, season_id: String) -> Dictionary:
	if n <= 0 or base_sell(item) <= 0:
		return {"ok": false, "reason": "not_buying", "total": 0}
	if not inventory.has(item, n):
		return {"ok": false, "reason": "no_item", "total": 0}
	var total := quote_sell(item, n, season_id)
	inventory.remove(item, n)
	_sold_today[item] = int(_sold_today.get(item, 0)) + n
	add_money(total)
	return {"ok": true, "reason": "", "total": total}


## Membeli dari toko dengan daftar stok; semua-atau-tidak.
func buy(inventory: Inventory, item: String, n: int, stock: Array) -> Dictionary:
	var price := buy_price(item)
	if n <= 0 or price <= 0 or not stock.has(item):
		return {"ok": false, "reason": "not_for_sale", "total": 0}
	var total := price * n
	if money < total:
		return {"ok": false, "reason": "no_money", "total": 0}
	if not inventory.can_add(item, n):
		return {"ok": false, "reason": "inventory_full", "total": 0}
	inventory.add(item, n)
	money -= total
	return {"ok": true, "reason": "", "total": total}


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "money": money, "sold_today": _sold_today.duplicate()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("sold_today", null)) != TYPE_DICTIONARY:
		return false
	var m := int(data.get("money", -1))
	if m < 0 or m > int(_cfg["max_money"]):
		return false
	var sold := {}
	for k in data["sold_today"]:
		var n := int(data["sold_today"][k])
		if n < 0 or not _prices.has(str(k)):
			return false
		sold[str(k)] = n
	money = m
	_sold_today = sold
	return true
