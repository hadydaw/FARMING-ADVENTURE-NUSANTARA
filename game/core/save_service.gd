extends Node
## Penyimpanan progres lokal (offline-first). Autoload "SaveService".
##
## - Tiap slot disimpan sebagai satu file JSON di user://saves/.
## - Penulisan atomik: tulis ke .tmp, cadangkan file lama ke .bak, baru ganti.
## - "revision" naik tiap simpan; dipakai nanti untuk sinkronisasi ke backend.
## - Isi "payload" ditentukan oleh sistem game (belum ada di tahap fondasi).
##
## Lihat docs/technical/TECHNICAL_ARCHITECTURE.md bagian "Penyimpanan Progres".

signal saved(slot: int)
signal loaded(slot: int)

const SAVE_DIR := "user://saves"
const SCHEMA_VERSION := 1
const MAX_SLOTS := 3


func slot_path(slot: int) -> String:
	return "%s/slot_%d.json" % [SAVE_DIR, slot]


func has_slot(slot: int) -> bool:
	return FileAccess.file_exists(slot_path(slot))


## Simpan payload ke slot. Mengembalikan OK bila berhasil.
func save_slot(slot: int, payload: Dictionary) -> Error:
	if slot < 0 or slot >= MAX_SLOTS:
		return ERR_INVALID_PARAMETER
	var err := DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	if err != OK:
		return err

	var revision := 1
	var previous := _read_envelope(slot_path(slot))
	if not previous.is_empty():
		revision = int(previous.get("revision", 0)) + 1

	var payload_json := JSON.stringify(payload, "", true)
	var envelope := {
		"schema_version": SCHEMA_VERSION,
		"game_version": str(ProjectSettings.get_setting("application/config/version", "0.0.0")),
		"revision": revision,
		"updated_at_unix": int(Time.get_unix_time_from_system()),
		"checksum": payload_json.sha256_text(),
		"payload_json": payload_json,
	}

	var path := slot_path(slot)
	var tmp_path := path + ".tmp"
	var bak_path := path + ".bak"

	var file := FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(envelope, "\t", true))
	file.flush()
	file = null # menutup file

	if FileAccess.file_exists(path):
		if FileAccess.file_exists(bak_path):
			DirAccess.remove_absolute(bak_path)
		err = DirAccess.rename_absolute(path, bak_path)
		if err != OK:
			return err
	err = DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		return err

	saved.emit(slot)
	return OK


## Muat payload dari slot. Bila file utama rusak, coba cadangan (.bak).
## Mengembalikan {} bila slot kosong atau tidak bisa dipulihkan.
func load_slot(slot: int) -> Dictionary:
	for path: String in [slot_path(slot), slot_path(slot) + ".bak"]:
		var envelope := _read_envelope(path)
		if envelope.is_empty():
			continue
		var payload_json := str(envelope.get("payload_json", ""))
		if payload_json.sha256_text() != str(envelope.get("checksum", "")):
			continue
		var parsed: Variant = JSON.parse_string(payload_json)
		if parsed is Dictionary:
			loaded.emit(slot)
			return parsed
	return {}


## Metadata ringan slot (untuk layar pilih slot). {} bila kosong.
func slot_info(slot: int) -> Dictionary:
	var envelope := _read_envelope(slot_path(slot))
	if envelope.is_empty():
		return {}
	return {
		"revision": int(envelope.get("revision", 0)),
		"updated_at_unix": int(envelope.get("updated_at_unix", 0)),
		"game_version": str(envelope.get("game_version", "")),
		"schema_version": int(envelope.get("schema_version", 0)),
	}


func delete_slot(slot: int) -> void:
	for suffix: String in ["", ".bak", ".tmp"]:
		var path := slot_path(slot) + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)


func _read_envelope(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var text := FileAccess.get_file_as_string(path)
	var json := JSON.new()
	if json.parse(text) != OK:
		return {}
	if json.data is Dictionary:
		return json.data
	return {}
