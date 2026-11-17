class_name GameClock
extends RefCounted
## Jam dan kalender permainan (D-055). Logika murni, tanpa node.
##
## - Satu-satunya sumber kebenaran waktu: `total_minutes` (menit sejak hari 0 pukul 00:00).
##   TIDAK pernah diturunkan dari jam perangkat.
## - Waktu hanya maju: delta negatif diabaikan; langkah besar dibatasi (`max_step_seconds`)
##   agar jeda/hitch tidak membuat waktu melompat.
## - Nilai konfigurasi (panjang hari, musim, fase, kecepatan) berasal dari data dan
##   SEMENTARA; keputusan desainnya masih terbuka (D-055/D-030).

signal minute_changed(total_minutes: int)
signal hour_changed(hour: int)
signal day_changed(day_index: int)
signal phase_changed(phase_id: String)
signal season_changed(season_id: String)
signal paused_changed(paused: bool)

const SAVE_VERSION := 1

var total_minutes: int = 0
var _config: Dictionary
var _accum: float = 0.0
var _pause_reasons: Dictionary = {}  # alasan -> true


func _init(config: Dictionary) -> void:
	_config = config
	total_minutes = _start_minutes()


## Memeriksa konfigurasi; mengembalikan daftar galat (kosong = valid).
static func validate_config(c: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	for key in ["game_minutes_per_real_second", "max_step_seconds"]:
		if not c.has(key) or float(c[key]) <= 0.0:
			errors.append("%s harus > 0" % key)
	for key in ["minutes_per_hour", "hours_per_day", "days_per_season"]:
		if not c.has(key) or int(c[key]) <= 0:
			errors.append("%s harus bilangan bulat > 0" % key)
	if not c.has("seasons") or (c["seasons"] as Array).is_empty():
		errors.append("seasons tidak boleh kosong")
	var phases: Array = c.get("phases", [])
	if phases.is_empty():
		errors.append("phases tidak boleh kosong")
	else:
		var last := -1
		for p in phases:
			var h := int(p.get("start_hour", -1))
			if h <= last:
				errors.append("start_hour fase harus naik ketat")
			last = h
		if int(phases[0].get("start_hour", -1)) != 0:
			errors.append("fase pertama harus mulai pukul 0")
		if c.has("hours_per_day") and last >= int(c["hours_per_day"]):
			errors.append("start_hour fase melebihi hours_per_day")
	if c.has("start_hour") and (int(c["start_hour"]) < 0 or int(c["start_hour"]) >= int(c.get("hours_per_day", 24))):
		errors.append("start_hour di luar rentang hari")
	return errors


# --- Turunan waktu ---

func minutes_per_hour() -> int:
	return int(_config["minutes_per_hour"])


func minutes_per_day() -> int:
	return int(_config["minutes_per_hour"]) * int(_config["hours_per_day"])


func day_index() -> int:
	return total_minutes / minutes_per_day()


func minute_of_day() -> int:
	return total_minutes % minutes_per_day()


func hour() -> int:
	return minute_of_day() / int(_config["minutes_per_hour"])


func minute() -> int:
	return minute_of_day() % int(_config["minutes_per_hour"])


func days_per_year() -> int:
	return int(_config["days_per_season"]) * (_config["seasons"] as Array).size()


## 1-based.
func day_of_season() -> int:
	return day_index() % int(_config["days_per_season"]) + 1


func season_index() -> int:
	return (day_index() / int(_config["days_per_season"])) % (_config["seasons"] as Array).size()


## Musim pada indeks hari mana pun (0-based), tanpa mengubah jam.
func season_id_for_day(day: int) -> String:
	var seasons: Array = _config["seasons"]
	return str(seasons[(maxi(day, 0) / int(_config["days_per_season"])) % seasons.size()])


func season_id() -> String:
	return str((_config["seasons"] as Array)[season_index()])


## 1-based.
func year() -> int:
	return day_index() / days_per_year() + 1


func phase_id() -> String:
	var h := hour()
	var result := ""
	for p in _config["phases"]:
		if h >= int(p["start_hour"]):
			result = str(p["id"])
	return result


func time_text() -> String:
	return "%02d:%02d" % [hour(), minute()]


# --- Jalannya waktu ---

func is_paused() -> bool:
	return not _pause_reasons.is_empty()


func pause(reason: String) -> void:
	var was := is_paused()
	_pause_reasons[reason] = true
	if not was:
		paused_changed.emit(true)


func resume(reason: String) -> void:
	if not _pause_reasons.has(reason):
		return
	_pause_reasons.erase(reason)
	if not is_paused():
		paused_changed.emit(false)


func pause_reasons() -> Array:
	return _pause_reasons.keys()


## Memajukan waktu berdasarkan detik nyata. Mengembalikan jumlah menit yang maju.
func advance(delta_seconds: float) -> int:
	if is_paused() or delta_seconds <= 0.0:
		return 0
	var step := minf(delta_seconds, float(_config["max_step_seconds"]))
	_accum += step * float(_config["game_minutes_per_real_second"])
	var whole := int(_accum)
	if whole <= 0:
		return 0
	_accum -= float(whole)
	add_minutes(whole)
	return whole


## Memajukan waktu menurut menit permainan (mis. tidur, perjalanan). Negatif ditolak.
func add_minutes(minutes: int) -> void:
	if minutes <= 0:
		return
	for i in minutes:
		_tick_one_minute()


func _tick_one_minute() -> void:
	var old_hour := hour()
	var old_day := day_index()
	var old_phase := phase_id()
	var old_season := season_id()
	total_minutes += 1
	minute_changed.emit(total_minutes)
	if hour() != old_hour:
		hour_changed.emit(hour())
	if day_index() != old_day:
		day_changed.emit(day_index())
	if phase_id() != old_phase:
		phase_changed.emit(phase_id())
	if season_id() != old_season:
		season_changed.emit(season_id())


## Seed deterministik per hari (D-055: hasil acak terkait waktu tidak dapat diulang
## lewat muat-ulang save). Campuran bilangan bulat sendiri, stabil lintas platform.
static func daily_seed(world_seed: int, day: int) -> int:
	# Konstanta splitmix64 ditulis sebagai bilangan bertanda 64-bit.
	var x: int = world_seed ^ (day * -7046029254386353131)
	x = (x ^ (x >> 30)) * -4658895280553007687
	x = (x ^ (x >> 27)) * -7723592293110705685
	return x ^ (x >> 31)


# --- Simpan / muat ---

func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "total_minutes": total_minutes}


## Memuat dari save. Mengembalikan false (dan tidak mengubah apa pun) bila data tidak valid.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION:
		return false
	var t: Variant = data.get("total_minutes", null)
	if typeof(t) != TYPE_INT and typeof(t) != TYPE_FLOAT:
		return false
	if float(t) < 0.0 or float(t) != floorf(float(t)):
		return false
	total_minutes = int(t)
	_accum = 0.0
	return true


func _start_minutes() -> int:
	return int(_config.get("start_hour", 0)) * int(_config["minutes_per_hour"])
