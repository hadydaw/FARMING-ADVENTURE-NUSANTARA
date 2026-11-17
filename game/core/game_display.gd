extends Node
## Layar, area aman, dan tema UI global (autoload "GameDisplay").
##
## - Landscape dipaksa lewat project.godot (sensor_landscape); stretch
##   canvas_items + aspect expand (viewport dasar 1280x720).
## - Area aman (notch/kamera lubang/gesture bar) dihitung dalam satuan viewport.
## - Tema UI dibangun dari kode (UiTheme) dan mengikuti pengaturan "text_scale".

signal safe_area_changed

var _theme_scale := -1.0


func _ready() -> void:
	get_tree().root.size_changed.connect(func(): safe_area_changed.emit())
	Events.setting_changed.connect(_on_setting_changed)
	apply_theme()


func apply_theme() -> void:
	var scale := 1.0
	if GameSettings.has_setting("text_scale"):
		scale = float(GameSettings.get_value("text_scale"))
	if is_equal_approx(scale, _theme_scale):
		return
	_theme_scale = scale
	get_tree().root.theme = UiTheme.build(scale)


func _on_setting_changed(id: String, _value: Variant) -> void:
	if id == "text_scale":
		apply_theme()


## Margin area aman dalam satuan viewport: {left, top, right, bottom}.
func safe_margins() -> Dictionary:
	if OS.get_name() != "Android":
		return {"left": 0.0, "top": 0.0, "right": 0.0, "bottom": 0.0}
	return compute_safe_margins(
		DisplayServer.window_get_size(),
		DisplayServer.get_display_safe_area(),
		get_tree().root.get_visible_rect().size)


## Fungsi murni (mudah diuji): hitung margin dari ukuran jendela (px), persegi
## area aman (px layar), dan ukuran viewport logis.
static func compute_safe_margins(window_size: Vector2i, safe_rect: Rect2i, viewport_size: Vector2) -> Dictionary:
	var zero := {"left": 0.0, "top": 0.0, "right": 0.0, "bottom": 0.0}
	if window_size.x <= 0 or window_size.y <= 0 or safe_rect.size.x <= 0 or safe_rect.size.y <= 0:
		return zero
	var sx := viewport_size.x / float(window_size.x)
	var sy := viewport_size.y / float(window_size.y)
	return {
		"left": maxf(0.0, safe_rect.position.x * sx),
		"top": maxf(0.0, safe_rect.position.y * sy),
		"right": maxf(0.0, (window_size.x - safe_rect.end.x) * sx),
		"bottom": maxf(0.0, (window_size.y - safe_rect.end.y) * sy),
	}


func orientation_name() -> String:
	match DisplayServer.screen_get_orientation():
		DisplayServer.SCREEN_LANDSCAPE: return "landscape"
		DisplayServer.SCREEN_PORTRAIT: return "portrait"
		DisplayServer.SCREEN_REVERSE_LANDSCAPE: return "reverse_landscape"
		DisplayServer.SCREEN_REVERSE_PORTRAIT: return "reverse_portrait"
		DisplayServer.SCREEN_SENSOR_LANDSCAPE: return "sensor_landscape"
		DisplayServer.SCREEN_SENSOR_PORTRAIT: return "sensor_portrait"
		DisplayServer.SCREEN_SENSOR: return "sensor"
	return "unknown"
