extends Node3D
## Layar boot / uji asap fondasi. BUKAN gameplay.
##
## Menampilkan diorama 3D stylized sederhana (pohon + rumah di pulau kecil) agar
## kita bisa memastikan di HP bahwa: render 3D jalan, orientasi landscape benar,
## sentuhan terbaca, dan terjemahan Indonesia/Inggris bekerja.

const LOCALES := ["id", "en"]

@onready var _title: Label = %Title
@onready var _subtitle: Label = %Subtitle
@onready var _info: Label = %Info
@onready var _lang_button: Button = %LangButton

var _pivot: Node3D


func _ready() -> void:
	TranslationServer.set_locale("id")
	_build_diorama()
	_lang_button.pressed.connect(_on_language_pressed)
	_refresh_texts()


func _process(delta: float) -> void:
	_pivot.rotate_y(delta * 0.35)
	_info.text = _info_text()


func _on_language_pressed() -> void:
	var idx := LOCALES.find(TranslationServer.get_locale().substr(0, 2))
	TranslationServer.set_locale(LOCALES[(idx + 1) % LOCALES.size()])
	_refresh_texts()


func _refresh_texts() -> void:
	_title.text = tr("BOOT_TITLE")
	_subtitle.text = tr("BOOT_SUBTITLE")
	_lang_button.text = tr("BOOT_LANGUAGE")


func _info_text() -> String:
	var info: Dictionary = AppInfo.build_info()
	return "%s\n%s\n%s" % [
		tr("BOOT_VERSION") % info["version"],
		tr("BOOT_RENDERER") % info["renderer"],
		tr("BOOT_FPS") % Engine.get_frames_per_second(),
	]


# --- Diorama placeholder (primitif; aset final menyusul sesuai GDD) -----------

func _build_diorama() -> void:
	_pivot = Node3D.new()
	add_child(_pivot)

	var camera := Camera3D.new()
	camera.position = Vector3(0, 3.2, 6.5)
	camera.fov = 50.0
	add_child(camera)
	camera.look_at(Vector3(0, 0.8, 0))

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-50, -30, 0)
	sun.light_energy = 1.2
	add_child(sun)

	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.53, 0.78, 0.92)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.85, 0.9, 1.0)
	env.ambient_light_energy = 0.6
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)

	# Pulau
	_add_mesh(_cylinder(2.6, 0.5), Color(0.42, 0.68, 0.30), Vector3(0, 0, 0))
	# Pohon
	_add_mesh(_cylinder(0.12, 0.8), Color(0.54, 0.35, 0.20), Vector3(-1.0, 0.65, 0))
	_add_mesh(_cone(0.6, 1.2), Color(0.18, 0.56, 0.31), Vector3(-1.0, 1.65, 0))
	# Rumah
	_add_mesh(_box(Vector3(1.2, 0.9, 1.0)), Color(0.86, 0.72, 0.50), Vector3(1.1, 0.7, 0))
	_add_mesh(_cone(0.95, 0.7, 4), Color(0.70, 0.28, 0.20), Vector3(1.1, 1.5, 0), 45.0)


func _add_mesh(mesh: Mesh, color: Color, pos: Vector3, yaw_degrees: float = 0.0) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	material.metallic_specular = 0.0
	mesh.surface_set_material(0, material)
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = pos
	instance.rotation_degrees.y = yaw_degrees
	_pivot.add_child(instance)


func _cylinder(radius: float, height: float) -> CylinderMesh:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	mesh.rings = 1
	return mesh


func _cone(radius: float, height: float, segments: int = 10) -> CylinderMesh:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.0
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = segments
	mesh.rings = 1
	return mesh


func _box(size: Vector3) -> BoxMesh:
	var mesh := BoxMesh.new()
	mesh.size = size
	return mesh
