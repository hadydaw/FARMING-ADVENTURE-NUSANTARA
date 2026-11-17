class_name FarmingSession
extends RefCounted
## Status pertanian satu permainan: inventory + petak lahan. Mendengar pergantian hari
## dari GameClock (bukan jam perangkat). Menyediakan payload simpan/muat.
## Semua nilai/konten di sini SEMENTARA (data uji teknis, bukan keputusan desain).

signal message(key: String, args: Array)

const SAVE_VERSION := 1

var inventory: Inventory
var grid: FarmGrid
var crop_defs: Dictionary = {}
var item_defs: Dictionary = {}
var _clock: GameClock


func _init(clock: GameClock, items: Array, crops: Array, plot_ids: Array, config: Dictionary) -> void:
	_clock = clock
	for it in items:
		item_defs[str(it["id"])] = it
	for c in crops:
		crop_defs[str(c["id"])] = c
	inventory = Inventory.new(int(config["inventory_slots"]), Callable(self, "_stack_max"))
	grid = FarmGrid.new(plot_ids, crop_defs)
	_config = config
	clock.day_changed.connect(_on_day_changed)
	reset()

var _config: Dictionary


func _stack_max(item_id: String) -> int:
	return int(item_defs.get(item_id, {}).get("stack_max", 0))


## Mulai baru: petak kosong, inventory berisi item awal dari data.
func reset() -> void:
	grid.reset()
	inventory.clear()
	for e in _config.get("start_items", []):
		inventory.add(str(e["item"]), int(e["count"]))


func _on_day_changed(_day: int) -> void:
	grid.advance_day(false)  # cuaca/hujan belum ada (D-023 terbuka); selalu false


## Aksi kontekstual pada petak. Mengembalikan hasil FarmActions.perform.
func act_on(plot_id: String) -> Dictionary:
	var plot := grid.plot(plot_id)
	if plot == null:
		return {"ok": false, "action": "", "reason": "unknown_plot"}
	return FarmActions.perform(plot, inventory, _clock.season_id(), crop_defs)


func preview(plot_id: String) -> Dictionary:
	var plot := grid.plot(plot_id)
	if plot == null:
		return {"action": "", "reason": "unknown_plot"}
	return FarmActions.decide(plot, inventory, _clock.season_id(), crop_defs)


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "inventory": inventory.to_dict(), "grid": grid.to_dict()}


## Semua-atau-tidak: bila salah satu bagian tidak valid, status tidak berubah.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("inventory", null)) != TYPE_DICTIONARY or typeof(data.get("grid", null)) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	if not inventory.from_dict(data["inventory"]):
		return false
	if not grid.from_dict(data["grid"]):
		inventory.from_dict(backup["inventory"])
		return false
	return true
