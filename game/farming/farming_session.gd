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


var world_seed: int = 0
var weather_types: Dictionary = {}
var weather_chances: Dictionary = {}


func _init(clock: GameClock, items: Array, crops: Array, plot_ids: Array, config: Dictionary,
		weather_type_rows: Array = [], weather_chance_rows: Array = [], seed_value: int = 0) -> void:
	_clock = clock
	world_seed = seed_value
	for w in weather_type_rows:
		weather_types[str(w["id"])] = w
	for w in weather_chance_rows:
		weather_chances[str(w["id"])] = w
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


## Cuaca pada hari tertentu (indeks hari, musim hari itu dihitung dari jam permainan).
func weather_on_day(day: int) -> String:
	return WeatherModel.weather_for(world_seed, day, _clock.season_id_for_day(day), weather_chances)

func weather_today() -> String:
	return weather_on_day(_clock.day_index())


func is_raining_today() -> bool:
	return _waters(weather_today())


func _waters(weather_id: String) -> bool:
	return bool(weather_types.get(weather_id, {}).get("waters_crops", false))


## Hari berganti: tanaman tumbuh menurut penyiraman/hujan pada hari yang BARU BERAKHIR.
func _on_day_changed(day: int) -> void:
	grid.advance_day(_waters(weather_on_day(day - 1)))


## Aksi kontekstual pada petak. Mengembalikan hasil FarmActions.perform.
func act_on(plot_id: String) -> Dictionary:
	var plot := grid.plot(plot_id)
	if plot == null:
		return {"ok": false, "action": "", "reason": "unknown_plot"}
	return FarmActions.perform(plot, inventory, _clock.season_id(), crop_defs, is_raining_today())


func preview(plot_id: String) -> Dictionary:
	var plot := grid.plot(plot_id)
	if plot == null:
		return {"action": "", "reason": "unknown_plot"}
	return FarmActions.decide(plot, inventory, _clock.season_id(), crop_defs, is_raining_today())


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "world_seed": world_seed, "inventory": inventory.to_dict(), "grid": grid.to_dict()}


## Semua-atau-tidak: bila salah satu bagian tidak valid, status tidak berubah.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("inventory", null)) != TYPE_DICTIONARY or typeof(data.get("grid", null)) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	var old_seed := world_seed
	if not inventory.from_dict(data["inventory"]):
		return false
	world_seed = int(data.get("world_seed", 0))
	if not grid.from_dict(data["grid"]):
		inventory.from_dict(backup["inventory"])
		world_seed = old_seed
		return false
	return true
