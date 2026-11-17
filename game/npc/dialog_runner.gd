class_name DialogRunner
extends RefCounted
## Pemilihan dan jalannya dialog (D-038). FORMAT DATA dan ATURAN PRIORITAS di sini
## SEMENTARA (keduanya masih terbuka di D-038): prioritas tertinggi menang, seri dipecah
## menurut id agar deterministik. Dialog bersyarat "never_auto" hanya dicapai lewat pilihan.

signal line_changed(line_key: String, choices: Array)
signal ended

var _dialogs: Dictionary = {}   # id -> row
var _social: SocialState
var _active: Dictionary = {}
var _line := 0
var _npc_id := ""


func _init(dialog_rows: Array, social: SocialState) -> void:
	for d in dialog_rows:
		_dialogs[str(d["id"])] = d
	_social = social


func is_active() -> bool:
	return not _active.is_empty()


func active_npc() -> String:
	return _npc_id


## ctx: {hour, weather, season, day}. Mengembalikan baris dialog terpilih atau {}.
func select(npc_id: String, ctx: Dictionary) -> Dictionary:
	var best: Dictionary = {}
	var ids: Array = _dialogs.keys()
	ids.sort()
	for id in ids:
		var d: Dictionary = _dialogs[id]
		if str(d["npc"]) != npc_id:
			continue
		if _matches(d, npc_id, ctx) and (best.is_empty() or int(d["priority"]) > int(best["priority"])):
			best = d
	return best


func _matches(d: Dictionary, npc_id: String, ctx: Dictionary) -> bool:
	var c: Dictionary = d.get("conditions", {})
	if bool(c.get("never_auto", false)):
		return false
	if bool(d.get("once_per_day", false)) and _social.seen_on_day(str(d["id"]), int(ctx.get("day", 0))):
		return false
	if c.has("weather") and str(c["weather"]) != str(ctx.get("weather", "")):
		return false
	if c.has("season") and str(c["season"]) != str(ctx.get("season", "")):
		return false
	if c.has("min_friendship") and _social.friendship(npc_id) < int(c["min_friendship"]):
		return false
	var hour := int(ctx.get("hour", 0))
	if c.has("hour_from") and hour < int(c["hour_from"]):
		return false
	if c.has("hour_to") and hour >= int(c["hour_to"]):
		return false
	return true


func start(npc_id: String, ctx: Dictionary) -> bool:
	if is_active():
		return false
	var d := select(npc_id, ctx)
	if d.is_empty():
		return false
	_begin(d, npc_id, int(ctx.get("day", 0)))
	return true


func _begin(d: Dictionary, npc_id: String, day: int) -> void:
	_active = d
	_npc_id = npc_id
	_line = 0
	_social.mark_seen(str(d["id"]), day)
	_emit_line()


func _emit_line() -> void:
	var last := _line >= (_active["lines"] as Array).size() - 1
	var texts: Array = []
	if last:
		for c in _active.get("choices", []):
			texts.append(str(c["text_key"]))
	line_changed.emit(str((_active["lines"] as Array)[_line]), texts)


## Lanjut ke baris berikut; di baris terakhir tanpa pilihan, dialog selesai.
func advance(day: int = 0) -> void:
	if not is_active():
		return
	if _line < (_active["lines"] as Array).size() - 1:
		_line += 1
		_emit_line()
	elif (_active.get("choices", []) as Array).is_empty():
		_end()


## Memilih jawaban (indeks); hanya sah di baris terakhir.
func choose(index: int, day: int = 0) -> bool:
	if not is_active() or _line < (_active["lines"] as Array).size() - 1:
		return false
	var choices: Array = _active.get("choices", [])
	if index < 0 or index >= choices.size():
		return false
	var c: Dictionary = choices[index]
	var delta := int(c.get("friendship", 0))
	if delta != 0:
		_social.change_friendship(_npc_id, delta)
	var next := str(c.get("next", ""))
	if next != "" and _dialogs.has(next):
		_begin(_dialogs[next], _npc_id, day)
	else:
		_end()
	return true


func _end() -> void:
	_active = {}
	_npc_id = ""
	_line = 0
	ended.emit()
