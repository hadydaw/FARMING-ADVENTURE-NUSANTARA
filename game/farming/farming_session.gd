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
var fish_species: Array = []
var fishing_config: Dictionary = {}
var livestock: LivestockState
var fishing_casts_today := 0
var economy: Economy
var shops: Dictionary = {}
var weather_types: Dictionary = {}
var weather_chances: Dictionary = {}


func _init(clock: GameClock, items: Array, crops: Array, plot_ids: Array, config: Dictionary,
		weather_type_rows: Array = [], weather_chance_rows: Array = [], seed_value: int = 0,
		meter_rows: Array = [], rest_cfg: Dictionary = {}, extras: Dictionary = {}) -> void:
	_clock = clock
	world_seed = seed_value
	rest_config = rest_cfg
	fish_species = extras.get("fish_species", [])
	fishing_config = extras.get("fishing_config", {})
	economy = Economy.new(extras.get("economy_config", {"start_money": 0, "max_money": 999999, "sold_drop": 0.1, "price_floor": 0.3, "season_multiplier": {}}), extras.get("item_prices", []))
	for sh in extras.get("shops", []):
		shops[str(sh["id"])] = sh
	var lcfg: Dictionary = extras.get("livestock_config", {"neglect_limit": 3, "pens": []})
	livestock = LivestockState.new(extras.get("animals", []), lcfg["pens"], int(lcfg["neglect_limit"]))
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
	economy.money = int(economy._cfg["start_money"])
	economy._sold_today.clear()
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
	livestock.advance_day()
	economy.advance_day()
	fishing_casts_today = 0


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
	return {"v": SAVE_VERSION, "world_seed": world_seed, "vitality": vitality.to_dict(), "livestock": livestock.to_dict(), "fishing_casts": fishing_casts_today, "economy": economy.to_dict(), "inventory": inventory.to_dict(), "grid": grid.to_dict()}


## Semua-atau-tidak: bila salah satu bagian tidak valid, status tidak berubah.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("inventory", null)) != TYPE_DICTIONARY or typeof(data.get("grid", null)) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	var old_seed := world_seed
	if typeof(data.get("vitality", null)) != TYPE_DICTIONARY or typeof(data.get("livestock", null)) != TYPE_DICTIONARY or int(data.get("fishing_casts", -1)) < 0 or typeof(data.get("economy", null)) != TYPE_DICTIONARY:
		return false
	if not vitality.from_dict(data["vitality"]):
		return false
	if not inventory.from_dict(data["inventory"]):
		vitality.from_dict(backup["vitality"])
		return false
	world_seed = int(data.get("world_seed", 0))
	if not grid.from_dict(data["grid"]) or not livestock.from_dict(data["livestock"]) or not economy.from_dict(data["economy"]):
		economy.from_dict(backup["economy"])
		grid.from_dict(backup["grid"])
		livestock.from_dict(backup["livestock"])
		inventory.from_dict(backup["inventory"])
		vitality.from_dict(backup["vitality"])
		world_seed = old_seed
		return false
	fishing_casts_today = int(data["fishing_casts"])
	return true


# --- Memancing (D-025, SEMENTARA) ---

func fishing_spot(spot_id: String) -> Dictionary:
	for sp in fishing_config.get("spots", []):
		if str(sp["id"]) == spot_id:
			return sp
	return {}


## Mulai melempar. Mengembalikan {ok, reason, cast}. Memakai stamina dan umpan (bila ada).
func begin_fishing(spot_id: String) -> Dictionary:
	var spot := fishing_spot(spot_id)
	if spot.is_empty():
		return {"ok": false, "reason": "unknown_spot", "cast": null}
	if sleep != null and sleep.is_sleeping():
		return {"ok": false, "reason": "sleeping", "cast": null}
	if not inventory.has("tool_fishing_rod"):
		return {"ok": false, "reason": "need_rod", "cast": null}
	var cost := int(rest_config.get("action_stamina_cost", {}).get("fish", 0)) if vitality.has_meter("stamina") else 0
	if cost > 0 and not vitality.can_spend("stamina", cost):
		return {"ok": false, "reason": "too_tired", "cast": null}
	var candidates := FishingModel.available(fish_species, str(spot["habitat"]), _clock.season_id(), weather_today(), _clock.hour())
	var bait := inventory.has("bait_test")
	var plan := FishingModel.plan_cast(world_seed, _clock.day_index(), fishing_casts_today, candidates, bait, fishing_config)
	if plan.is_empty():
		return {"ok": false, "reason": "no_fish", "cast": null}
	var item := str(_fish_def(str(plan["species_id"]))["item"])
	if not inventory.can_add(item, 1):
		return {"ok": false, "reason": "inventory_full", "cast": null}
	if cost > 0:
		vitality.spend("stamina", cost)
	if bait:
		inventory.remove("bait_test", 1)
	fishing_casts_today += 1
	return {"ok": true, "reason": "", "cast": FishingCast.new(plan)}


func _fish_def(species_id: String) -> Dictionary:
	for f in fish_species:
		if str(f["id"]) == species_id:
			return f
	return {}


## Menyelesaikan lemparan: bila tertangkap, ikan masuk inventory. Mengembalikan item atau "".
func finish_fishing(cast: FishingCast) -> String:
	if cast == null or cast.state != FishingCast.CAUGHT:
		return ""
	var item := str(_fish_def(cast.species_id)["item"])
	inventory.add(item, 1)
	return item


# --- Peternakan (D-024, SEMENTARA) ---

func animal_preview(animal_id: String) -> Dictionary:
	return livestock.decide(animal_id, inventory)


func animal_act(animal_id: String) -> Dictionary:
	if sleep != null and sleep.is_sleeping():
		return {"ok": false, "action": "", "reason": "sleeping"}
	return livestock.perform(animal_id, inventory)


# --- Toko (D-021, SEMENTARA) ---

func shop_buy(shop_id: String, item: String, n: int = 1) -> Dictionary:
	if not shops.has(shop_id):
		return {"ok": false, "reason": "unknown", "total": 0}
	return economy.buy(inventory, item, n, shops[shop_id]["stock"])


func shop_sell(item: String, n: int = 1) -> Dictionary:
	return economy.sell(inventory, item, n, _clock.season_id())
