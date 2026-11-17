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
var gather: GatherState
var combat: CombatState
var realtime: RealtimeCombat
var quests: QuestState
var dungeon: DungeonState
var achievements: AchievementState
var festivals: FestivalCalendar
var upgrades: UpgradeState
var companions: CompanionState
var character: CharacterState
var _base_slots := 0
var recipes: Array = []
var stations: Array = []
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
	gather = GatherState.new(extras.get("gather_nodes", []))
	combat = CombatState.new(extras.get("monsters", []), extras.get("monster_spawns", []), extras.get("combat_config", {"base_attack": 1, "player_defense": 0, "stamina_cost": 0, "faint_money_loss": 0.0, "faint_health_fraction": 0.5, "attack_per_level": 0, "level_exp": [0]}))
	quests = QuestState.new(extras.get("quests", []), extras.get("guild_config", {"max_active": 2, "ranks": [{"points": 0, "name_key": "RANK_0"}]}))
	dungeon = DungeonState.new(extras.get("dungeons", []), extras.get("monsters", []))
	achievements = AchievementState.new(extras.get("achievements", []))
	festivals = FestivalCalendar.new(extras.get("festivals", []))
	upgrades = UpgradeState.new(extras.get("upgrades", []))
	companions = CompanionState.new(extras.get("companions", []))
	character = CharacterState.new(extras.get("character_options", []))
	realtime = RealtimeCombat.new(extras.get("combat_config", {"player_cooldown": 0.0, "monster_interval": 1.0, "aggro_range": 0.0, "attack_range": 0.0, "monster_speed": 0.0, "leash": 0.0}))
	recipes = extras.get("recipes", [])
	stations = extras.get("stations", [])
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
	_base_slots = int(config["inventory_slots"])
	inventory = Inventory.new(_base_slots, Callable(self, "_stack_max"))
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
	gather._last_gathered.clear()
	combat.reset()
	quests.reset()
	dungeon.reset()
	achievements.reset()
	festivals.reset()
	upgrades.reset()
	companions.reset()
	character.reset()
	_apply_upgrades()
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
	return {"v": SAVE_VERSION, "world_seed": world_seed, "vitality": vitality.to_dict(), "livestock": livestock.to_dict(), "fishing_casts": fishing_casts_today, "economy": economy.to_dict(), "gather": gather.to_dict(), "combat": combat.to_dict(), "quests": quests.to_dict(), "dungeon": dungeon.to_dict(), "achievements": achievements.to_dict(), "festivals": festivals.to_dict(), "upgrades": upgrades.to_dict(), "companions": companions.to_dict(), "character": character.to_dict(), "inventory": inventory.to_dict(), "grid": grid.to_dict()}


## Terapkan efek upgrade (slot tas, meter maksimum) dari himpunan upgrade yang dimiliki.
func _apply_upgrades() -> void:
	combat.bonus_attack = companions.attack_bonus()
	combat.bonus_guard = companions.guard_bonus()
	inventory.set_slot_count(_base_slots + upgrades.bonus_slots())
	for id in vitality.ids():
		vitality.set_max_bonus(str(id), upgrades.meter_bonus(str(id)))


## Semua-atau-tidak, termasuk upgrade (ukuran tas/meter bergantung padanya, jadi diterapkan dulu).
func from_dict(data: Dictionary) -> bool:
	if typeof(data.get("upgrades", {})) != TYPE_DICTIONARY or typeof(data.get("companions", {})) != TYPE_DICTIONARY or typeof(data.get("character", {})) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	if data.has("character"):
		if not character.from_dict(data["character"]):
			return false
	else:
		character.reset()
	if data.has("companions"):
		if not companions.from_dict(data["companions"]):
			character.from_dict(backup["character"])
			return false
	else:
		companions.reset()
	if data.has("upgrades"):
		if not upgrades.from_dict(data["upgrades"]):
			companions.from_dict(backup["companions"])
			character.from_dict(backup["character"])
			return false
	else:
		upgrades.reset()
	_apply_upgrades()
	if _from_dict_core(data):
		return true
	upgrades.from_dict(backup["upgrades"])
	companions.from_dict(backup["companions"])
	character.from_dict(backup["character"])
	_apply_upgrades()
	inventory.from_dict(backup["inventory"])
	vitality.from_dict(backup["vitality"])
	return false


func _from_dict_core(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	if typeof(data.get("inventory", null)) != TYPE_DICTIONARY or typeof(data.get("grid", null)) != TYPE_DICTIONARY:
		return false
	var backup := to_dict()
	var old_seed := world_seed
	if typeof(data.get("vitality", null)) != TYPE_DICTIONARY or typeof(data.get("livestock", null)) != TYPE_DICTIONARY or int(data.get("fishing_casts", -1)) < 0 or typeof(data.get("economy", null)) != TYPE_DICTIONARY or typeof(data.get("gather", null)) != TYPE_DICTIONARY:
		return false
	if (data.has("combat") and typeof(data["combat"]) != TYPE_DICTIONARY) or (data.has("quests") and typeof(data["quests"]) != TYPE_DICTIONARY) or (data.has("dungeon") and typeof(data["dungeon"]) != TYPE_DICTIONARY) or (data.has("achievements") and typeof(data["achievements"]) != TYPE_DICTIONARY) or (data.has("festivals") and typeof(data["festivals"]) != TYPE_DICTIONARY):
		return false
	if not vitality.from_dict(data["vitality"]):
		return false
	if not inventory.from_dict(data["inventory"]):
		vitality.from_dict(backup["vitality"])
		return false
	world_seed = int(data.get("world_seed", 0))
	if not grid.from_dict(data["grid"]) or not livestock.from_dict(data["livestock"]) or not economy.from_dict(data["economy"]) or not gather.from_dict(data["gather"]) or (data.has("combat") and not combat.from_dict(data["combat"])) or (data.has("quests") and not quests.from_dict(data["quests"])) or (data.has("dungeon") and not dungeon.from_dict(data["dungeon"])) or (data.has("achievements") and not achievements.from_dict(data["achievements"])) or (data.has("festivals") and not festivals.from_dict(data["festivals"])):
		festivals.from_dict(backup["festivals"])
		achievements.from_dict(backup["achievements"])
		dungeon.from_dict(backup["dungeon"])
		quests.from_dict(backup["quests"])
		combat.from_dict(backup["combat"])
		gather.from_dict(backup["gather"])
		economy.from_dict(backup["economy"])
		grid.from_dict(backup["grid"])
		livestock.from_dict(backup["livestock"])
		inventory.from_dict(backup["inventory"])
		vitality.from_dict(backup["vitality"])
		world_seed = old_seed
		return false
	if not data.has("combat"):
		combat.reset()
	if not data.has("quests"):
		quests.reset()
	if not data.has("dungeon"):
		dungeon.reset()
	if not data.has("achievements"):
		achievements.reset()
	if not data.has("festivals"):
		festivals.reset()
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


# --- Crafting, pakai item, pengumpulan (SEMENTARA) ---

func recipe_by_id(recipe_id: String) -> Dictionary:
	for r in recipes:
		if str(r["id"]) == recipe_id:
			return r
	return {}


func craft(recipe_id: String) -> Dictionary:
	var r := recipe_by_id(recipe_id)
	if r.is_empty():
		return {"ok": false, "reason": "unknown"}
	return Crafting.craft(r, inventory)


func use_item(item_id: String) -> Dictionary:
	return ItemUse.use(item_id, item_defs, inventory, vitality)


func attack_monster(spawn_id: String) -> Dictionary:
	var r := combat.attack(spawn_id, _clock.day_index(), world_seed, inventory, item_defs, vitality, economy)
	if bool(r["defeated"]):
		quests.on_defeat(str(combat.spawn_monster(spawn_id)["id"]))
	return r


func claim_festival() -> Dictionary:
	return festivals.claim_today(_clock, inventory, combat)


func stats() -> Dictionary:
	return {"kills": combat.kills, "level": combat.level(), "money": economy.money, "rank": quests.rank(), "dungeons_cleared": dungeon._last_clear.size()}


## Periksa pencapaian/petunjuk baru; mengembalikan baris yang baru terbuka.
func check_milestones() -> Array:
	return achievements.evaluate(stats())


func companion_recruit(id: String) -> Dictionary:
	return companions.recruit(id, economy)


func companion_toggle(id: String) -> Dictionary:
	var r := companions.toggle_active(id)
	_apply_upgrades()
	return r


func upgrade_buy(id: String) -> Dictionary:
	var r := upgrades.buy(id, inventory, economy)
	if bool(r["ok"]):
		_apply_upgrades()
	return r


func dungeon_start(id: String) -> Dictionary:
	return dungeon.start(id, _clock.day_index(), world_seed)


func dungeon_attack() -> Dictionary:
	return dungeon.attack(_clock.day_index(), combat, inventory, item_defs, vitality, economy, quests)


## Serang waktu-nyata: tanpa balasan instan (monster membalas sendiri lewat monster_retaliate).
## Gagal "cooldown" bila terlalu cepat.
func strike_monster(spawn_id: String) -> Dictionary:
	if not realtime.can_strike():
		return {"ok": false, "reason": "cooldown", "dealt": 0, "taken": 0, "defeated": false, "drops": [], "exp": 0, "fainted": false, "leveled": false}
	var r := combat.attack(spawn_id, _clock.day_index(), world_seed, inventory, item_defs, vitality, economy, false)
	if bool(r["ok"]):
		realtime.mark_strike()
	if bool(r["defeated"]):
		quests.on_defeat(str(combat.spawn_monster(spawn_id)["id"]))
	return r


func monster_retaliate(spawn_id: String) -> Dictionary:
	return combat.retaliate(spawn_id, vitality, economy)


func quest_accept(id: String) -> Dictionary:
	return quests.accept(id, inventory)


func quest_turn_in(id: String) -> Dictionary:
	return quests.turn_in(id, inventory, economy, combat)


func gather_at(node_id: String) -> Dictionary:
	return gather.gather(node_id, _clock.day_index(), inventory)
