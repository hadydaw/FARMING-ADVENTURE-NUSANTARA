extends Control
## Scene awal: menampilkan nama game sesaat lalu masuk ke menu utama.
## Layanan inti (autoload) sudah siap saat scene ini dimuat.

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var label := Label.new()
	label.text = tr("BOOT_LOADING")
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(label)
	await get_tree().process_frame
	SceneManager.go("main_menu", false, false)
