class_name CombatState
extends RefCounted
## Pertarungan dasar tukar-serang (D-013/D-019, SEMENTARA): tiap serangan pemain dibalas monster
## bila masih hidup. Monster tersebar di titik spawn, bangkit lagi setelah beberapa hari.
## Acak (drop) deterministik dari seed dunia + spawn + hari + jumlah kalahkan.
## Level/EXP ditaruh di sini agar satu paket simpan (D-018, sementara).

const SAVE_VERSION := 1

var config: Dictionary
var exp_total := 0
var _roll_cb: Callable   # sumber acak 0..1 untuk efek status (diisi sesi)
var bonus_attack := 0   # dari companion aktif (turunan, tidak disimpan)
var bonus_guard := 0
var equip_attack := 0     # dari perlengkapan (turunan, tidak disimpan)
var equip_defense := 0
var status_attack := 0    # dari status efek (turunan)
var kills := 0
var _monsters: Dictionary = {}   # id monster -> row
var _spawns: Dictionary = {}     # id spawn -> row
var _hp: Dictionary = {}         # id spawn -> sisa HP (tidak ada = penuh)
var _dead_day: Dictionary = {}   # id spawn -> hari dikalahkan


func _init(monster_rows: Array, spawn_rows: Array, cfg: Dictionary) -> void:
	for m in monster_rows:
		_monsters[str(m["id"])] = m
	for sp in spawn_rows:
		_spawns[str(sp["id"])] = sp
	config = cfg


func level() -> int:
	var lv := 1
	var th: Array = config.get("level_exp", [0])
	for i in range(1, th.size()):
		if exp_total >= int(th[i]):
			lv = i + 1
	return lv


## Pertahanan pemain (dasar + penahan companion).
func player_defense() -> int:
	return int(config["player_defense"]) + bonus_guard + equip_defense


func spawn_monster(spawn_id: String) -> Dictionary:
	return _monsters.get(str((_spawns.get(spawn_id, {}) as Dictionary).get("monster", "")), {})


func is_alive(spawn_id: String, day: int) -> bool:
	if not _spawns.has(spawn_id):
		return false
	if not _dead_day.has(spawn_id):
		return true
	return day - int(_dead_day[spawn_id]) >= int(spawn_monster(spawn_id)["respawn_days"])


func hp_of(spawn_id: String, day: int) -> int:
	if not is_alive(spawn_id, day):
		return 0
	return int(_hp.get(spawn_id, int(spawn_monster(spawn_id)["hp"])))


## Serangan pemain = dasar + perlengkapan + level + teman + status (min 1). Parameter lama tidak dipakai.
func player_attack(_inventory: Inventory = null, _item_defs: Dictionary = {}) -> int:
	return maxi(int(config["base_attack"]) + equip_attack + (level() - 1) * int(config["attack_per_level"]) + bonus_attack + status_attack, 1)


## Satu putaran serang. Mengembalikan {ok, reason, dealt, taken, defeated, drops:[{item,count}], exp, fainted, leveled}.
func attack(spawn_id: String, day: int, world_seed: int, inventory: Inventory, item_defs: Dictionary, vitality: Vitality, economy: Economy, counter: bool = true) -> Dictionary:
	var res := {"ok": false, "reason": "", "dealt": 0, "taken": 0, "defeated": false, "drops": [], "exp": 0, "fainted": false, "leveled": false, "inflict": ""}
	if not _spawns.has(spawn_id):
		res["reason"] = "unknown"
		return res
	if not is_alive(spawn_id, day):
		res["reason"] = "not_here"
		return res
	if vitality.value("health") <= 0:
		res["reason"] = "no_health"
		return res
	var cost := int(config["stamina_cost"])
	if vitality.has_meter("stamina") and not vitality.spend("stamina", cost):
		res["reason"] = "too_tired"
		return res
	var mon := spawn_monster(spawn_id)
	var dealt := maxi(1, player_attack(inventory, item_defs) - int(mon["defense"]))
	var hp := hp_of(spawn_id, day) - dealt
	res["ok"] = true
	res["dealt"] = dealt
	if hp <= 0:
		_hp.erase(spawn_id)
		_dead_day[spawn_id] = day
		kills += 1
		res["defeated"] = true
		res["exp"] = int(mon["exp"])
		var lv_before := level()
		exp_total += int(mon["exp"])
		res["leveled"] = level() > lv_before
		res["drops"] = _roll_drops(mon, spawn_id, day, world_seed, inventory)
		return res
	_hp[spawn_id] = hp
	if counter:
		var back := retaliate(spawn_id, vitality, economy, 1.0 if _roll_cb.is_null() else float(_roll_cb.call()))
		res["taken"] = back["taken"]
		res["fainted"] = back["fainted"]
		res["inflict"] = back["inflict"]
	return res


## Serangan balik monster ke pemain (tukar-pukul langsung atau waktu-nyata). Pingsan: uang berkurang,
## HP pulih sebagian, monster pulih penuh. {taken, fainted}
func retaliate(spawn_id: String, vitality: Vitality, economy: Economy, roll: float = 1.0) -> Dictionary:
	var out := {"taken": 0, "fainted": false, "inflict": ""}
	if not _spawns.has(spawn_id) or vitality.value("health") <= 0:
		return out
	var mon := spawn_monster(spawn_id)
	var taken := maxi(0, int(mon["attack"]) - player_defense())
	out["taken"] = absi(vitality.change("health", -taken))
	var inf: Dictionary = mon.get("inflict", {})
	if not inf.is_empty() and roll < float(inf["chance"]) and vitality.value("health") > 0:
		out["inflict"] = str(inf["effect"])
	if vitality.value("health") <= 0:
		out["fainted"] = true
		_hp.erase(spawn_id)
		var loss := int(floor(float(economy.money) * float(config["faint_money_loss"])))
		economy.money -= loss
		vitality.change("health", int(ceil(float(vitality.max_value("health")) * float(config["faint_health_fraction"]))))
	return out


## Monster pulih penuh (mis. pemain kabur melewati batas kejar).
func heal_spawn(spawn_id: String) -> void:
	_hp.erase(spawn_id)


func _roll_drops(mon: Dictionary, spawn_id: String, day: int, world_seed: int, inventory: Inventory) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|%s|%d|%d" % [world_seed, spawn_id, day, kills])
	var out: Array = []
	for d in mon["drops"]:
		if rng.randf() < float(d["chance"]):
			var item := str(d["item"])
			var count := int(d["count"])
			if inventory.can_add(item, count):
				inventory.add(item, count)
				out.append({"item": item, "count": count})
	return out


func set_roll_source(cb: Callable) -> void:
	_roll_cb = cb


func reset() -> void:
	exp_total = 0
	kills = 0
	_hp.clear()
	_dead_day.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "exp": exp_total, "kills": kills, "hp": _hp.duplicate(), "dead": _dead_day.duplicate()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or int(data.get("exp", -1)) < 0 or int(data.get("kills", -1)) < 0:
		return false
	if typeof(data.get("hp", null)) != TYPE_DICTIONARY or typeof(data.get("dead", null)) != TYPE_DICTIONARY:
		return false
	var hp: Dictionary = {}
	for k in data["hp"]:
		if not _spawns.has(str(k)) or int(data["hp"][k]) <= 0:
			return false
		hp[str(k)] = int(data["hp"][k])
	var dead: Dictionary = {}
	for k in data["dead"]:
		if not _spawns.has(str(k)):
			return false
		dead[str(k)] = int(data["dead"][k])
	exp_total = int(data["exp"])
	kills = int(data["kills"])
	_hp = hp
	_dead_day = dead
	return true
