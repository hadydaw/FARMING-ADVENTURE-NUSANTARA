extends TestCase


func run() -> void:
	# Tanpa data -> nol.
	var zero := GameDisplay.compute_safe_margins(Vector2i.ZERO, Rect2i(), Vector2(1280, 720))
	check_near(zero["left"], 0.0, "jendela 0 -> margin 0")
	zero = GameDisplay.compute_safe_margins(Vector2i(2400, 1080), Rect2i(), Vector2(1280, 720))
	check_near(zero["right"], 0.0, "area aman kosong -> margin 0")

	# Layar penuh aman -> nol.
	var full := GameDisplay.compute_safe_margins(Vector2i(2400, 1080), Rect2i(0, 0, 2400, 1080), Vector2(1280, 720))
	check_near(full["left"] + full["top"] + full["right"] + full["bottom"], 0.0, "area aman penuh -> semua 0")

	# Notch: 120 px kiri dan 60 px kanan, 24 px bawah; skala viewport 1280/2400.
	var m := GameDisplay.compute_safe_margins(Vector2i(2400, 1080), Rect2i(120, 0, 2220, 1056), Vector2(1280, 720))
	check_near(m["left"], 120.0 * 1280.0 / 2400.0, "margin kiri terskala")
	check_near(m["right"], 60.0 * 1280.0 / 2400.0, "margin kanan terskala")
	check_near(m["bottom"], 24.0 * 720.0 / 1080.0, "margin bawah terskala")
	check_near(m["top"], 0.0, "margin atas 0")

	# Area aman lebih besar dari jendela tidak menghasilkan margin negatif.
	var over := GameDisplay.compute_safe_margins(Vector2i(1000, 500), Rect2i(-50, -50, 1200, 700), Vector2(1000, 500))
	check(over["left"] >= 0.0 and over["right"] >= 0.0 and over["top"] >= 0.0 and over["bottom"] >= 0.0, "margin tidak negatif")

	check(GameDisplay.orientation_name() != "", "nama orientasi tersedia")
	check_eq(int(ProjectSettings.get_setting("display/window/handheld/orientation")), 4, "orientasi proyek = sensor landscape")
	check_eq(str(ProjectSettings.get_setting("rendering/renderer/rendering_method")), "gl_compatibility", "renderer GL Compatibility")
	check_eq(int(ProjectSettings.get_setting("display/window/size/viewport_width")), 1280, "viewport dasar 1280")
	check_eq(int(ProjectSettings.get_setting("display/window/size/viewport_height")), 720, "viewport dasar 720")

	# Wadah area aman memberi padding tambahan.
	var safe := SafeAreaContainer.new()
	safe.extra_padding = 10
	tree.root.add_child(safe)
	await wait_frames(1)
	check_eq(safe.get_theme_constant("margin_left"), 10, "padding tambahan diterapkan")
	safe.queue_free()

	# Aksesibilitas: kontras tinggi dan skala teks pada tema
	var normal_theme := UiTheme.build(1.0, false)
	var contrast_theme := UiTheme.build(1.0, true)
	var nb := normal_theme.get_stylebox("normal", "Button") as StyleBoxFlat
	var cb := contrast_theme.get_stylebox("normal", "Button") as StyleBoxFlat
	check(nb.bg_color != cb.bg_color, "tema kontras tinggi beda dari normal")
	check_eq(cb.border_width_left, 3, "tombol kontras tinggi berbingkai putih")
	check_eq(nb.border_width_left, 0, "tombol normal tanpa bingkai")
	check(contrast_theme.get_color("font_color", "Label").is_equal_approx(Color(1, 1, 1)), "teks putih murni di kontras tinggi")
	check_eq(UiTheme.build(1.5, false).default_font_size, 36, "skala teks 1.5x")
	for id in ["high_contrast", "message_duration", "show_hints", "text_scale"]:
		check(GameSettings.has_setting(id) and str(GameSettings.get_row(id)["category"]) == "accessibility", "pengaturan aksesibilitas: %s" % id)
		check(tr(str(GameSettings.get_row(id)["label_key"])) != str(GameSettings.get_row(id)["label_key"]), "terjemahan %s" % id)
	check(not bool(GameSettings.default_value("high_contrast")) and bool(GameSettings.default_value("show_hints")), "bawaan: kontras mati, petunjuk hidup")
