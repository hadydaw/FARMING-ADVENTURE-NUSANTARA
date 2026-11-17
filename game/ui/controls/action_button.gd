class_name ActionButton
extends Control
## Tombol aksi sentuh multi-touch. Menekan/melepas aksi InputMap sehingga kode
## gameplay memakai Input.is_action_pressed yang sama untuk sentuh, keyboard, dan
## gamepad. Digambar dengan primitif UI sementara; bukan aset visual final.

@export var action: StringName = &"interact"
@export var label_key: String = ""
@export var radius: float = 56.0

var pressed: bool = false

var _touch := -1


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2.ONE * radius * 2.0


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if _touch != -1:
				return
			var local := get_global_transform_with_canvas().affine_inverse() * touch.position
			if local.distance_to(size / 2.0) > radius * 1.15:
				return
			_touch = touch.index
			_set_pressed(true)
			get_viewport().set_input_as_handled()
		elif touch.index == _touch:
			_touch = -1
			_set_pressed(false)
			get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED and not is_visible_in_tree():
		_force_release()
	elif what == NOTIFICATION_EXIT_TREE:
		_force_release()
	elif what == NOTIFICATION_TRANSLATION_CHANGED:
		queue_redraw()


func _force_release() -> void:
	if pressed:
		_touch = -1
		_set_pressed(false)


func _set_pressed(value: bool) -> void:
	pressed = value
	if value:
		Input.action_press(action)
	else:
		Input.action_release(action)
	queue_redraw()


func _draw() -> void:
	var c := size / 2.0
	draw_circle(c, radius, Color(1, 1, 1, 0.34 if pressed else 0.14))
	draw_arc(c, radius, 0.0, TAU, 48, Color(1, 1, 1, 0.55), 3.0)
	if label_key != "":
		var font := get_theme_default_font()
		var font_size := get_theme_default_font_size()
		var text := tr(label_key)
		var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
		draw_string(font, c + Vector2(-text_size.x / 2.0, text_size.y / 4.0), text,
			HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(1, 1, 1, 0.95))
