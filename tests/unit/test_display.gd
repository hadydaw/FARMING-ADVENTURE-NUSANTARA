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
