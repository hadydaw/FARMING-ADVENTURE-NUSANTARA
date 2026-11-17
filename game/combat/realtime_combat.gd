class_name RealtimeCombat
extends RefCounted
## Pertarungan waktu-nyata dasar (D-013, SEMENTARA): jeda serang pemain dan keputusan monster
## (diam/kejar/tunggu/serang) murni berbasis waktu delta; gerak fisik dan penerapan damage ada di dunia
## dan CombatState. Tidak disimpan (hanya keadaan sesaat).

var cfg: Dictionary
var player_cd := 0.0
var _mon_cd: Dictionary = {}   # id spawn -> sisa jeda serang


func _init(config: Dictionary) -> void:
	cfg = config


func tick(delta: float) -> void:
	player_cd = maxf(player_cd - delta, 0.0)


func can_strike() -> bool:
	return player_cd <= 0.0


func mark_strike() -> void:
	player_cd = float(cfg["player_cooldown"])


## "idle" (di luar jangkauan), "chase" (mendekat), "wait" (dalam jangkauan, menunggu jeda), "attack".
func monster_decision(spawn_id: String, distance: float, delta: float) -> String:
	if distance > float(cfg["aggro_range"]):
		_mon_cd.erase(spawn_id)
		return "idle"
	if distance > float(cfg["attack_range"]):
		return "chase"
	var left := float(_mon_cd.get(spawn_id, float(cfg["monster_interval"]))) - delta
	if left <= 0.0:
		_mon_cd[spawn_id] = float(cfg["monster_interval"])
		return "attack"
	_mon_cd[spawn_id] = left
	return "wait"


func reset() -> void:
	player_cd = 0.0
	_mon_cd.clear()
