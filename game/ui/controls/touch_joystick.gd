class_name TouchJoystick
extends Control
## Joystick virtual (D-034 kontrol hybrid). Mendukung multi-touch: hanya sentuhan
## yang dimulai di dalam area joystick yang dilacak, sehingga dapat dipakai
## bersamaan dengan tombol aksi. Jenis tetap/mengambang, ukuran, dan zona mati
## mengikuti pengaturan pemain. Keluaran dikirim ke InputService.
## Digambar dengan primitif UI sementara; bukan aset visual final.

signal vector_changed(vector: Vector2)

enum Mode { FIXED, FLOATING }

const BASE_RADIUS := 100.0

@export var mode: Mode = Mode.FIXED
@export var size_scale: float = 1.0
@export_range(0.0, 0.9) var dead_zone: float = 0.15
@export var follow_settings: bool = true

var vector: Vector2 = Vector2.ZERO

var _touch := -1
var _center := Vector2.ZERO
var _knob := Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_center = size / 2.0
	resized.connect(_on_resized)
	if follow_settings:
		apply_settings()
		Events.setting_changed.connect(func(_id, _v): apply_settings())


func radius() -> float:
	return BASE_RADIUS * size_scale


func is_active() -> bool:
	return _touch != -1


func apply_settings() -> void:
	mode = Mode.FLOATING if str(GameSettings.get_value("joystick_mode")) == "floating" else Mode.FIXED
	size_scale = float(GameSettings.get_value("joystick_size"))
	dead_zone = float(GameSettings.get_value("joystick_deadzone"))
	queue_redraw()


func _on_resized() -> void:
	if _touch == -1:
		_center = size / 2.0
		queue_redraw()


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if _touch != -1:
				return
			var local := _to_local_point(touch.position)
			if not _accepts(local):
				return
			_touch = touch.index
			if mode == Mode.FLOATING:
				_center = local
			_update(local)
			get_viewport().set_input_as_handled()
		elif touch.index == _touch:
			_release()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch:
			_update(_to_local_point(drag.position))
			get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and not is_visible_in_tree() and _touch != -1:
		_release()
	elif what == NOTIFICATION_EXIT_TREE and _touch != -1:
		_release()


func _to_local_point(global_point: Vector2) -> Vector2:
	return get_global_transform_with_canvas().affine_inverse() * global_point


func _accepts(local: Vector2) -> bool:
	if mode == Mode.FIXED:
		return local.distance_to(size / 2.0) <= radius() * 1.4
	return Rect2(Vector2.ZERO, size).has_point(local)


func _update(local: Vector2) -> void:
	var raw := ((local - _center) / radius()).limit_length(1.0)
	_knob = raw * radius()
	var magnitude := raw.length()
	var out := Vector2.ZERO
	if magnitude >= dead_zone:
		out = raw.normalized() * ((magnitude - dead_zone) / (1.0 - dead_zone))
	_emit(out)
	queue_redraw()


func _release() -> void:
	_touch = -1
	_knob = Vector2.ZERO
	_center = size / 2.0
	_emit(Vector2.ZERO)
	queue_redraw()


func _emit(out: Vector2) -> void:
	vector = out
	InputService.set_touch_move(out)
	vector_changed.emit(out)


func _draw() -> void:
	if mode == Mode.FLOATING and _touch == -1:
		return
	var r := radius()
	draw_circle(_center, r, Color(1, 1, 1, 0.12))
	draw_arc(_center, r, 0.0, TAU, 48, Color(1, 1, 1, 0.38), 3.0)
	draw_circle(_center + _knob, r * 0.4, Color(1, 1, 1, 0.5))
