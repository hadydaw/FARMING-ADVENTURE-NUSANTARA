extends Node
## Layanan pengaturan terpusat (autoload "GameSettings"), D-045.
##
## - Skema berbasis data (game/data/settings_schema.json): menambah opsi tidak
##   butuh perubahan UI manual.
## - Disimpan terpisah dari progres game di user://settings.cfg (D-045 butir 8),
##   tulis atomik (.tmp -> .bak -> ganti) dengan pemulihan dari cadangan.
## - Nilai tidak valid ditolak atau dibatasi ke rentang; kunci tak dikenal dibuang.
## - Sinkronisasi cloud untuk pengaturan akun belum diimplementasikan.

signal changed(id: String, value: Variant)

const SCHEMA_VERSION := 1
const DEFAULT_PATH := "user://settings.cfg"
const SAVE_DELAY := 0.4
const VOLUME_BUSES := {"music_volume": "Music", "sfx_volume": "SFX", "ambience_volume": "Ambience"}

var path: String = DEFAULT_PATH
## False pada uji agar pengaturan tidak mengubah mesin (locale, bus audio).
var apply_effects: bool = true

var _rows: Array = []
var _by_id: Dictionary = {}
var _values: Dictionary = {}
var _dirty := false
var _timer: Timer


func _ready() -> void:
	AudioBuses.ensure()
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = SAVE_DELAY
	_timer.timeout.connect(flush)
	add_child(_timer)
	var errors := setup(DataRegistry.rows("settings"))
	for e in errors:
		push_error("GameSettings: " + e)
	load_from_disk()
	apply_all()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		flush()


## Memasang skema. Mengembalikan galat validasi (kosong bila skema sah).
func setup(rows: Array) -> Array[String]:
	var errors: Array[String] = []
	_rows = []
	_by_id = {}
	_values = {}
	for row_variant in rows:
		var row: Dictionary = row_variant
		var id := str(row.get("id", ""))
		var type := str(row.get("type", ""))
		for key in ["category", "label_key", "default"]:
			if not row.has(key):
				errors.append("%s: field '%s' wajib" % [id, key])
		if type == "enum":
			if not (row.get("options", []) as Array).has(row.get("default")):
				errors.append("%s: default harus salah satu options" % id)
		elif type == "float":
			if not (row.has("min") and row.has("max")) or float(row.get("min", 0)) >= float(row.get("max", 0)):
				errors.append("%s: min/max tidak valid" % id)
		elif type != "bool":
			errors.append("%s: tipe tidak dikenal '%s'" % [id, type])
		_rows.append(row)
		_by_id[id] = row
	if errors.is_empty():
		for id in _by_id:
			_values[id] = default_value(id)
	return errors


func rows() -> Array:
	return _rows


func has_setting(id: String) -> bool:
	return _by_id.has(id)


func categories() -> Array[String]:
	var result: Array[String] = []
	for row in _rows:
		var c := str((row as Dictionary)["category"])
		if not result.has(c):
			result.append(c)
	return result


func rows_in(category: String) -> Array:
	return _rows.filter(func(r): return str((r as Dictionary)["category"]) == category)


func get_row(id: String) -> Dictionary:
	return _by_id.get(id, {})


func default_value(id: String) -> Variant:
	var row: Dictionary = _by_id[id]
	if row.get("default_from_device", false):
		var device_lang := OS.get_locale_language()
		if (row.get("options", []) as Array).has(device_lang):
			return device_lang
	var d: Variant = row["default"]
	return float(d) if str(row["type"]) == "float" else d


func get_value(id: String) -> Variant:
	return _values.get(id, null)


## Menetapkan nilai. False bila ID tak dikenal atau nilai tidak valid.
func set_value(id: String, value: Variant) -> bool:
	if not _by_id.has(id):
		return false
	var normalized: Variant = _normalize(_by_id[id], value)
	if normalized == null:
		return false
	if _values[id] == normalized:
		return true
	_values[id] = normalized
	_dirty = true
	_apply(id)
	changed.emit(id, normalized)
	if apply_effects:
		Events.setting_changed.emit(id, normalized)
	if _timer != null and is_inside_tree():
		_timer.start()
	return true


func reset_value(id: String) -> void:
	if _by_id.has(id):
		set_value(id, default_value(id))


func reset_category(category: String) -> void:
	for row in rows_in(category):
		reset_value(str((row as Dictionary)["id"]))


func reset_all() -> void:
	for id in _by_id:
		reset_value(str(id))


func apply_all() -> void:
	for id in _by_id:
		_apply(str(id))


## Memuat dari disk: berkas utama, lalu cadangan, lalu bawaan.
## Mengembalikan "main", "backup", atau "defaults".
func load_from_disk() -> String:
	for id in _by_id:
		_values[id] = default_value(str(id))
	if _try_load(path):
		return "main"
	if _try_load(path + ".bak"):
		_dirty = true  # tulis ulang berkas utama dari cadangan
		return "backup"
	return "defaults"


## Simpan bila ada perubahan. Atomik: .tmp -> cadangkan lama ke .bak -> ganti.
func flush() -> Error:
	if not _dirty:
		return OK
	var cfg := ConfigFile.new()
	cfg.set_value("meta", "schema_version", SCHEMA_VERSION)
	for id in _values:
		cfg.set_value("settings", id, _values[id])
	var tmp := path + ".tmp"
	var bak := path + ".bak"
	var err := cfg.save(tmp)
	if err != OK:
		return err
	if FileAccess.file_exists(path):
		if FileAccess.file_exists(bak):
			DirAccess.remove_absolute(bak)
		DirAccess.rename_absolute(path, bak)
	err = DirAccess.rename_absolute(tmp, path)
	if err == OK:
		_dirty = false
	return err


func _try_load(p: String) -> bool:
	if not FileAccess.file_exists(p):
		return false
	var cfg := ConfigFile.new()
	if cfg.load(p) != OK or not cfg.has_section("settings"):
		return false
	for id in _by_id:
		if cfg.has_section_key("settings", str(id)):
			var n: Variant = _normalize(_by_id[id], cfg.get_value("settings", str(id)))
			if n != null:
				_values[id] = n
	return true


func _normalize(row: Dictionary, value: Variant) -> Variant:
	match str(row["type"]):
		"bool":
			return value if typeof(value) == TYPE_BOOL else null
		"enum":
			if typeof(value) != TYPE_STRING and typeof(value) != TYPE_STRING_NAME:
				return null
			var s := str(value)
			return s if (row["options"] as Array).has(s) else null
		"float":
			if typeof(value) != TYPE_FLOAT and typeof(value) != TYPE_INT:
				return null
			var f := float(value)
			if is_nan(f) or is_inf(f):
				return null
			var step := float(row.get("step", 0.0))
			if step > 0.0:
				f = snappedf(f, step)
			return clampf(f, float(row["min"]), float(row["max"]))
	return null


func _apply(id: String) -> void:
	if not apply_effects:
		return
	var v: Variant = _values[id]
	if id == "language":
		TranslationServer.set_locale(str(v))
		Events.language_changed.emit(str(v))
	elif VOLUME_BUSES.has(id):
		AudioBuses.set_linear(str(VOLUME_BUSES[id]), float(v))
