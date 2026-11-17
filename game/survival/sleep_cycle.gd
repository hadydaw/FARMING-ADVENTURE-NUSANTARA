class_name SleepCycle
extends RefCounted
## Tidur dan pergantian hari (D-056). Memajukan jam permainan ke jam bangun secara
## BERTAHAP (step), agar pemrosesan pergantian hari tidak berat dalam satu frame.
## Aturan waktu tidur dan efek pemulihan SEMENTARA (data rest_config).

signal finished

const PAUSE_REASON := "sleeping"

var _clock: GameClock
var _vitality: Vitality
var _cfg: Dictionary
var _target := -1


func _init(clock: GameClock, vitality: Vitality, config: Dictionary) -> void:
	_clock = clock
	_vitality = vitality
	_cfg = config


func is_sleeping() -> bool:
	return _target >= 0


## Menit permainan total saat bangun: jam bangun berikutnya setelah sekarang.
func wake_target() -> int:
	var wake_minute_of_day := int(_cfg["wake_hour"]) * _clock.minutes_per_hour()
	var day_start := _clock.day_index() * _clock.minutes_per_day()
	var target := day_start + wake_minute_of_day
	if target <= _clock.total_minutes:
		target += _clock.minutes_per_day()
	return target


func begin() -> bool:
	if is_sleeping():
		return false
	_target = wake_target()
	_clock.pause(PAUSE_REASON)  # waktu nyata tidak ikut menambah selama tidur
	return true


## Maju paling banyak `budget_minutes`. Mengembalikan true bila tidur selesai.
func step(budget_minutes: int = -1) -> bool:
	if not is_sleeping():
		return false
	var budget := int(_cfg["step_minutes"]) if budget_minutes <= 0 else budget_minutes
	var remaining := _target - _clock.total_minutes
	_clock.add_minutes(mini(budget, maxi(remaining, 0)))
	if _clock.total_minutes >= _target:
		_target = -1
		_clock.resume(PAUSE_REASON)
		for id in _cfg.get("restore_on_sleep", []):
			_vitality.restore_full(str(id))
		finished.emit()
		return true
	return false
