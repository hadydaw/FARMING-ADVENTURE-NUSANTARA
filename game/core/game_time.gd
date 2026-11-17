extends Node
## Penyedia waktu permainan global (autoload "GameTime"). Membungkus GameClock,
## menjalankannya dari _process, dan meneruskan perubahan ke Events.
##
## Waktu berhenti saat aplikasi di latar belakang kecuali konfigurasi
## `run_in_background` true (nilai sementara; D-055 belum memutuskan).

var clock: GameClock
var config: Dictionary = {}
var errors: Array[String] = []


func _ready() -> void:
	setup(DataRegistry.get_row("time_config", "default"))


func setup(cfg: Dictionary) -> void:
	config = cfg
	errors = GameClock.validate_config(cfg)
	if not errors.is_empty():
		for e in errors:
			push_error("GameTime: " + e)
		cfg = _fallback_config()
		config = cfg
	clock = GameClock.new(cfg)
	clock.minute_changed.connect(func(m): Events.time_changed.emit(m))
	clock.hour_changed.connect(func(h): Events.hour_changed.emit(h))
	clock.day_changed.connect(func(d): Events.day_changed.emit(d))
	clock.phase_changed.connect(func(p): Events.phase_changed.emit(p))
	clock.season_changed.connect(func(s): Events.season_changed.emit(s))
	clock.paused_changed.connect(func(p): Events.time_paused_changed.emit(p))


func _process(delta: float) -> void:
	if clock != null:
		clock.advance(delta)


func _notification(what: int) -> void:
	if clock == null or bool(config.get("run_in_background", false)):
		return
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		clock.pause("app_background")
	elif what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		clock.resume("app_background")


func new_game() -> void:
	setup(config)


static func _fallback_config() -> Dictionary:
	return {
		"game_minutes_per_real_second": 1.0, "minutes_per_hour": 60, "hours_per_day": 24,
		"days_per_season": 28, "seasons": ["season_1", "season_2", "season_3", "season_4"],
		"start_hour": 6, "max_step_seconds": 1.0, "run_in_background": false,
		"phases": [{"id": "night", "start_hour": 0}, {"id": "morning", "start_hour": 5},
			{"id": "day", "start_hour": 11}, {"id": "evening", "start_hour": 17}, {"id": "night", "start_hour": 20}],
	}
