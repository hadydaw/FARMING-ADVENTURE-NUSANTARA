class_name UiTheme
extends RefCounted
## Tema UI fungsional (BUKAN art direction final). Dibangun dari kode agar
## ukuran teks mengikuti pengaturan aksesibilitas (D-045). Target sentuh minimum
## dijaga lewat padding tombol. Warna sementara sampai ART_DIRECTION disetujui.

const BASE_FONT_SIZE := 24
const MIN_TOUCH_HEIGHT := 64.0

const COLOR_TEXT := Color(0.96, 0.97, 0.95)
const COLOR_TEXT_DISABLED := Color(0.62, 0.65, 0.62)
const COLOR_PANEL := Color(0.09, 0.13, 0.11, 0.92)
const COLOR_BUTTON := Color(0.20, 0.42, 0.30)
const COLOR_BUTTON_HOVER := Color(0.26, 0.52, 0.37)
const COLOR_BUTTON_PRESSED := Color(0.14, 0.32, 0.22)
const COLOR_BUTTON_DISABLED := Color(0.22, 0.25, 0.23)


static func build(text_scale: float = 1.0, high_contrast: bool = false) -> Theme:
	var theme := Theme.new()
	theme.default_font_size = roundi(BASE_FONT_SIZE * text_scale)

	var c_button := Color(0, 0, 0) if high_contrast else COLOR_BUTTON
	var c_hover := Color(0.15, 0.15, 0.15) if high_contrast else COLOR_BUTTON_HOVER
	var c_pressed := Color(0.3, 0.3, 0.3) if high_contrast else COLOR_BUTTON_PRESSED
	var c_disabled := Color(0.12, 0.12, 0.12) if high_contrast else COLOR_BUTTON_DISABLED
	var normal := _box(c_button)
	var hover := _box(c_hover)
	var pressed := _box(c_pressed)
	var disabled := _box(c_disabled)
	if high_contrast:
		for b in [normal, hover, pressed]:
			b.border_color = Color(1, 1, 1)
			b.set_border_width_all(3)
		disabled.border_color = Color(0.7, 0.7, 0.7)
		disabled.set_border_width_all(2)
	var focus := _box(Color(0, 0, 0, 0))
	focus.border_color = Color(1, 0.86, 0.35)
	focus.set_border_width_all(3)
	for type_name in ["Button", "OptionButton", "CheckButton", "MenuButton"]:
		theme.set_stylebox("normal", type_name, normal)
		theme.set_stylebox("hover", type_name, hover)
		theme.set_stylebox("pressed", type_name, pressed)
		theme.set_stylebox("disabled", type_name, disabled)
		theme.set_stylebox("focus", type_name, focus)
		theme.set_color("font_color", type_name, COLOR_TEXT)
		theme.set_color("font_hover_color", type_name, COLOR_TEXT)
		theme.set_color("font_pressed_color", type_name, COLOR_TEXT)
		theme.set_color("font_disabled_color", type_name, Color(0.78, 0.78, 0.78) if high_contrast else COLOR_TEXT_DISABLED)
	theme.set_color("font_color", "Label", Color(1, 1, 1) if high_contrast else COLOR_TEXT)
	if high_contrast:
		theme.set_color("font_outline_color", "Label", Color(0, 0, 0))
		theme.set_constant("outline_size", "Label", 4)

	var panel := _box(Color(0, 0, 0, 1) if high_contrast else COLOR_PANEL)
	panel.content_margin_left = 20
	panel.content_margin_right = 20
	panel.content_margin_top = 16
	panel.content_margin_bottom = 16
	theme.set_stylebox("panel", "PanelContainer", panel)
	theme.set_stylebox("panel", "Panel", panel)
	return theme


static func _box(color: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.set_corner_radius_all(10)
	box.content_margin_left = 20
	box.content_margin_right = 20
	box.content_margin_top = 14
	box.content_margin_bottom = 14
	return box
