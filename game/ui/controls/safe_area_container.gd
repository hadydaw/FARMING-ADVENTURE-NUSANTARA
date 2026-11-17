class_name SafeAreaContainer
extends MarginContainer
## Wadah yang menjaga isi di dalam area aman layar (notch, kamera lubang, bilah gesture).

@export var extra_padding: int = 16


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	GameDisplay.safe_area_changed.connect(refresh)
	refresh()


func refresh() -> void:
	var m := GameDisplay.safe_margins()
	add_theme_constant_override("margin_left", int(m["left"]) + extra_padding)
	add_theme_constant_override("margin_top", int(m["top"]) + extra_padding)
	add_theme_constant_override("margin_right", int(m["right"]) + extra_padding)
	add_theme_constant_override("margin_bottom", int(m["bottom"]) + extra_padding)
