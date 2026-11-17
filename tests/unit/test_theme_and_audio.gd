extends TestCase


func run() -> void:
	check_eq(UiTheme.build(1.0).default_font_size, UiTheme.BASE_FONT_SIZE, "skala 1.0")
	check_eq(UiTheme.build(1.5).default_font_size, 36, "skala 1.5")
	check(UiTheme.build(1.0).has_stylebox("normal", "Button"), "tombol punya gaya")

	# text_scale mengubah tema global lewat event bus.
	GameSettings.set_value("text_scale", 1.5)
	check_eq(tree.root.theme.default_font_size, 36, "tema global mengikuti text_scale 1.5")
	GameSettings.set_value("text_scale", 0.8)
	check_eq(tree.root.theme.default_font_size, roundi(UiTheme.BASE_FONT_SIZE * 0.8), "tema global mengikuti text_scale 0.8")
	GameSettings.reset_value("text_scale")
	check_eq(tree.root.theme.default_font_size, UiTheme.BASE_FONT_SIZE, "reset mengembalikan tema")

	# Bus audio dan volume.
	for bus_name in AudioBuses.BUSES:
		check(AudioServer.get_bus_index(bus_name) >= 0, "bus '%s' ada" % bus_name)
	GameSettings.set_value("music_volume", 0.0)
	check(AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")), "volume 0 membisukan bus")
	GameSettings.set_value("music_volume", 0.5)
	var idx := AudioServer.get_bus_index("Music")
	check(not AudioServer.is_bus_mute(idx), "volume 0.5 tidak bisu")
	check_near(db_to_linear(AudioServer.get_bus_volume_db(idx)), 0.5, "volume bus mengikuti pengaturan", 0.01)
	GameSettings.reset_value("music_volume")

	# Bahasa.
	GameSettings.set_value("language", "id")
	GameSettings.set_value("language", "en")
	check_eq(TranslationServer.get_locale().substr(0, 2), "en", "bahasa Inggris diterapkan")
	check_eq(tr("COMMON_BACK"), "Back", "terjemahan en")
	GameSettings.set_value("language", "id")
	check_eq(tr("COMMON_BACK"), "Kembali", "terjemahan id")
