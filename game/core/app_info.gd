extends Node
## Informasi aplikasi (nama, versi, platform). Autoload "AppInfo".
## Tidak berisi logika gameplay.

const GAME_NAME := "Farming Adventure Nusantara"

var version: String = "0.0.0"
var is_android: bool = false


func _ready() -> void:
	version = str(ProjectSettings.get_setting("application/config/version", "0.0.0"))
	is_android = OS.get_name() == "Android"


## Ringkasan build untuk layar debug dan laporan bug.
func build_info() -> Dictionary:
	return {
		"name": GAME_NAME,
		"version": version,
		"platform": OS.get_name(),
		"godot": Engine.get_version_info().get("string", "?"),
		"renderer": str(ProjectSettings.get_setting("rendering/renderer/rendering_method", "?")),
	}
