extends Node
## Perpindahan scene (autoload "SceneManager").
##
## - Scene diacu lewat ID stabil dari tabel data "scenes" (bukan path hardcode).
## - Transisi memudar singkat; sentuhan diblokir selama transisi.
## - Riwayat sederhana untuk tombol Back; di Android, Back pada layar teratas keluar aplikasi.
## - Hasil dilaporkan lewat Events.scene_changed / scene_change_failed.

const FADE_TIME := 0.18

var current_id: String = ""
var quit_when_empty: bool = OS.get_name() == "Android"

var _history: Array[String] = []
var _busy := false
var _overlay: ColorRect


func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(_overlay)
	Events.back_requested.connect(back)


func is_busy() -> bool:
	return _busy


func history() -> Array[String]:
	return _history.duplicate()


## Pindah ke scene berID. `push_history` menyimpan scene sekarang untuk Back.
func go(scene_id: String, push_history: bool = true, animate: bool = true) -> void:
	if _busy:
		push_warning("SceneManager sibuk; permintaan '%s' diabaikan" % scene_id)
		Events.scene_change_failed.emit(scene_id, "busy")
		return
	if not DataRegistry.has_row("scenes", scene_id):
		_fail(scene_id, "unknown_scene")
		return
	var path := str(DataRegistry.get_row("scenes", scene_id).get("path", ""))
	if not ResourceLoader.exists(path):
		_fail(scene_id, "missing_resource")
		return

	_busy = true
	Events.scene_change_started.emit(scene_id)
	if animate:
		await _fade(1.0)
	var packed := load(path) as PackedScene
	if packed == null or get_tree().change_scene_to_packed(packed) != OK:
		if animate:
			await _fade(0.0)
		_busy = false
		_fail(scene_id, "load_failed")
		return
	# change_scene_to_packed menukar scene di akhir frame; tunggu sampai selesai.
	await get_tree().process_frame
	await get_tree().process_frame
	if push_history and current_id != "":
		_history.append(current_id)
	current_id = scene_id
	if animate:
		await _fade(0.0)
	_busy = false
	Events.scene_changed.emit(scene_id)


## Kembali ke scene sebelumnya; bila riwayat kosong, keluar aplikasi (Android).
func back() -> void:
	if _busy:
		return
	if _history.is_empty():
		if quit_when_empty:
			get_tree().quit()
		return
	var target: String = _history.pop_back()
	await go(target, false)


func _fail(scene_id: String, reason: String) -> void:
	push_error("SceneManager: gagal pindah ke '%s' (%s)" % [scene_id, reason])
	Events.scene_change_failed.emit(scene_id, reason)


func _fade(target_alpha: float) -> void:
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP if target_alpha > 0.0 or _busy else Control.MOUSE_FILTER_IGNORE
	var tween := create_tween()
	tween.tween_property(_overlay, "color:a", target_alpha, FADE_TIME)
	await tween.finished
	if target_alpha <= 0.0:
		_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
