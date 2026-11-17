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
var vitality: Vitality
var sleep: SleepCycle
var rest_config: Dictionary = {}
var weather_types: Dictionary = {}
var weather_chances: Dictionary = {}


func _init(clock: GameClock, items: Array, crops: Array, plot_ids: Array, config: Dictionary,
		weather_type_rows: Array = [], weather_chance_rows: Array = [], seed_value: int = 0,
		meter_rows: Array = [], rest_cfg: Dictionary = {}) -> void:
	_clock = clock
	world_seed = seed_value
	rest_config = rest_cfg
	vitality = Vitality.new(meter_rows)
	if not rest_cfg.is_empty():
		sleep = SleepCycle.new(clock, vitality, rest_cfg)
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
	for id in vitality.ids():
		vitality.restore_full(id)
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
	if sleep != null and sleep.is_sleeping():
		return {"ok": false, "action": "", "reason": "sleeping"}
	var d := FarmActions.decide(plot, inventory, _clock.season_id(), crop_defs, is_raining_today())
	var cost := 0
	if vitality.has_meter("stamina"):
		cost = int(rest_config.get("action_stamina_cost", {}).get(str(d["action"]), 0))
	if str(d["action"]) != "" and cost > 0 and not vitality.can_spend("stamina", cost):
		return {"ok": false, "action": "", "reason": "too_tired"}
	var res := FarmActions.perform(plot, inventory, _clock.season_id(), crop_defs, is_raining_today())
	if bool(res["ok"]) and cost > 0:
		vitality.spend("stamina", cost)
	return res


func preview(plot_id: String) -> Dictionary:
	var plot := grid.plot(plot_id)
	if plot == null:
		return {"action": "", "reason": "unknown_plot"}
	return FarmActions.decide(plot, inventory, _clock.season_id(), crop_defs, is_raining_today())


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "world_seed": world_seed, "vitality": vitality.to_dict(), "inventory": inventory.to_dict(), "grid": grid.to_dict()}


## Semua-atau-tidak: bila salah satu bagian tidak valid, status tidak berubah.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("inventory", null)) != TYPE_DICTIONARY or typeof(data.get("grid", null)) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	var old_seed := world_seed
	if typeof(data.get("vitality", null)) != TYPE_DICTIONARY:
		return false
	if not vitality.from_dict(data["vitality"]):
		return false
	if not inventory.from_dict(data["inventory"]):
		vitality.from_dict(backup["vitality"])
		return false
	world_seed = int(data.get("world_seed", 0))
	if not grid.from_dict(data["grid"]):
		inventory.from_dict(backup["inventory"])
		vitality.from_dict(backup["vitality"])
		world_seed = old_seed
		return false
	return true
