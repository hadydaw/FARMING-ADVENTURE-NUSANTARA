extends Node
## Registri data game (autoload "DataRegistry").
##
## Prinsip data-driven (TECHNICAL_ARCHITECTURE.md bagian 4): definisi sistem
## berupa tabel JSON dengan ID stabil (snake_case, unik), bukan hardcode.
## Registri hanya memuat dan memvalidasi tabel; isi konten gameplay (item,
## tanaman, dst.) baru ditambahkan oleh milestone yang bersangkutan.

const ID_REGEX := "^[a-z][a-z0-9_]*$"
const TABLES := {
	"scenes": "res://game/data/scenes.json",
	"settings": "res://game/data/settings_schema.json",
	"input_actions": "res://game/data/input_actions.json",
	"time_config": "res://game/data/time_config.json",
	"camera_profiles": "res://game/data/camera_profiles.json",
	"camera_limits": "res://game/data/camera_limits.json",
	"interaction_types": "res://game/data/interaction_types.json",
	"world_props": "res://game/data/world_props.json",
	"world_start_layout": "res://game/data/world_start_layout.json",
	"items": "res://game/data/items.json",
	"crops": "res://game/data/crops.json",
	"farm_config": "res://game/data/farm_config.json",
	"farm_plots": "res://game/data/farm_plots.json",
}

var load_errors: Array[String] = []
var _rows: Dictionary = {}   # table_id -> Array[Dictionary]
var _index: Dictionary = {}  # table_id -> {id -> Dictionary}


func _ready() -> void:
	load_errors = load_all()
	for e in load_errors:
		push_error("DataRegistry: " + e)


## Memuat semua tabel bawaan. Mengembalikan daftar galat (kosong bila sukses).
func load_all() -> Array[String]:
	var errors: Array[String] = []
	for table_id in TABLES:
		errors.append_array(load_table(str(table_id), str(TABLES[table_id])))
	return errors


func load_table(table_id: String, path: String, id_field: String = "id") -> Array[String]:
	var errors: Array[String] = []
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		errors.append("%s: berkas tidak terbaca atau kosong: %s" % [table_id, path])
		return errors
	var parsed := parse_rows(text, id_field)
	for e in parsed["errors"]:
		errors.append("%s: %s" % [table_id, e])
	if errors.is_empty():
		_rows[table_id] = parsed["rows"]
		_index[table_id] = parsed["index"]
	return errors


## Mem-parse teks JSON menjadi baris tabel dan memvalidasi ID (format dan keunikan).
static func parse_rows(text: String, id_field: String = "id") -> Dictionary:
	var errors: Array[String] = []
	var rows: Array = []
	var index: Dictionary = {}
	var json := JSON.new()
	if json.parse(text) != OK:
		errors.append("JSON tidak valid (baris %d): %s" % [json.get_error_line(), json.get_error_message()])
		return {"rows": rows, "index": index, "errors": errors}
	if typeof(json.data) != TYPE_ARRAY:
		errors.append("akar JSON harus berupa array")
		return {"rows": rows, "index": index, "errors": errors}
	var regex := RegEx.create_from_string(ID_REGEX)
	var data: Array = json.data
	for i in data.size():
		var row: Variant = data[i]
		if typeof(row) != TYPE_DICTIONARY:
			errors.append("baris %d bukan objek" % i)
			continue
		var id := str((row as Dictionary).get(id_field, ""))
		if regex.search(id) == null:
			errors.append("baris %d: ID tidak valid '%s'" % [i, id])
			continue
		if index.has(id):
			errors.append("ID ganda: %s" % id)
			continue
		index[id] = row
		rows.append(row)
	return {"rows": rows, "index": index, "errors": errors}


func has_table(table_id: String) -> bool:
	return _rows.has(table_id)


func rows(table_id: String) -> Array:
	return _rows.get(table_id, [])


func ids(table_id: String) -> Array:
	return (_index.get(table_id, {}) as Dictionary).keys()


func has_row(table_id: String, id: String) -> bool:
	return (_index.get(table_id, {}) as Dictionary).has(id)


func get_row(table_id: String, id: String) -> Dictionary:
	return (_index.get(table_id, {}) as Dictionary).get(id, {})
