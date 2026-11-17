class_name CameraRig
extends Node3D
## Rig kamera adaptif (D-033). Mengikuti target, berpindah profil konteks
## (farming/exploration/interaction) dengan halus, mendukung zoom dan rotasi
## dengan batas. Nilai profil dan batas berasal dari data dan SEMENTARA.
## Gestur/skema kontrol kamera belum diputuskan (D-034): rig hanya menyediakan API.

signal profile_changed(profile_id: String)

var target_position: Vector3 = Vector3.ZERO
var yaw_deg: float = 0.0
var zoom: float = 1.0
var profile_id: String = ""

var _profiles: Dictionary = {}   # id -> Dictionary
var _limits: Dictionary = {}
var _camera: Camera3D
# Keadaan terhaluskan
var _distance: float = 9.0
var _pitch_deg: float = 50.0
var _fov: float = 45.0
var _focus: Vector3 = Vector3.ZERO
var _goal_distance: float = 9.0
var _goal_pitch: float = 50.0
var _goal_fov: float = 45.0
var _transition_seconds: float = 0.5


func _init() -> void:
	_camera = Camera3D.new()
	add_child(_camera)


## Memuat profil dan batas dari tabel data (atau kamus yang diberikan untuk uji).
func configure(profiles: Array, limits: Dictionary) -> void:
	_profiles.clear()
	for p in profiles:
		_profiles[str(p["id"])] = p
	_limits = limits
	zoom = clampf(zoom, zoom_min(), zoom_max())


func configure_from_registry() -> void:
	configure(DataRegistry.rows("camera_profiles"), DataRegistry.get_row("camera_limits", "default"))


func camera() -> Camera3D:
	return _camera


func has_profile(id: String) -> bool:
	return _profiles.has(id)


func zoom_min() -> float:
	return float(_limits.get("zoom_min", 0.7))


func zoom_max() -> float:
	return float(_limits.get("zoom_max", 1.5))


## Mengganti profil konteks; peralihan mengikuti `transition_seconds`.
## Mengembalikan false bila profil tidak dikenal.
func set_profile(id: String, instant: bool = false) -> bool:
	if not _profiles.has(id):
		return false
	var p: Dictionary = _profiles[id]
	profile_id = id
	_goal_distance = float(p["distance"])
	_goal_pitch = clampf(float(p["pitch_deg"]), float(_limits.get("pitch_min_deg", 15.0)), float(_limits.get("pitch_max_deg", 70.0)))
	_goal_fov = float(p["fov"])
	_transition_seconds = maxf(float(p.get("transition_seconds", 0.5)), 0.001)
	_smoothing = float(p.get("follow_smoothing", 8.0))
	if instant:
		_distance = _goal_distance
		_pitch_deg = _goal_pitch
		_fov = _goal_fov
		_focus = target_position
		_apply_pose()
	profile_changed.emit(id)
	return true


var _smoothing: float = 8.0


## Memindahkan fokus langsung (teleport/pindah wilayah) tanpa meluncur.
func snap_to(pos: Vector3) -> void:
	target_position = pos
	_focus = pos
	_apply_pose()


func rotate_by(delta_deg: float) -> void:
	var limit := float(_limits.get("yaw_limit_deg", 180.0))
	yaw_deg = clampf(yaw_deg + delta_deg, -limit, limit)


func zoom_by(factor: float) -> void:
	zoom = clampf(zoom * factor, zoom_min(), zoom_max())


## Memajukan rig satu langkah (dipanggil dari _process; dapat dipanggil langsung saat uji).
func step(delta: float) -> void:
	var follow := smooth_factor(_smoothing, delta)
	_focus = _focus.lerp(target_position, follow)
	var blend := smooth_factor(6.0 / _transition_seconds, delta)
	_distance = lerpf(_distance, _goal_distance, blend)
	_pitch_deg = lerpf(_pitch_deg, _goal_pitch, blend)
	_fov = lerpf(_fov, _goal_fov, blend)
	_apply_pose()


func _process(delta: float) -> void:
	step(delta)


func _apply_pose() -> void:
	var pose := compute_pose(_focus, yaw_deg, _pitch_deg, _distance * zoom)
	_camera.transform = pose
	_camera.fov = _fov


## Faktor penghalusan tak bergantung frame rate (0..1).
static func smooth_factor(smoothing: float, delta: float) -> float:
	return 1.0 - exp(-maxf(smoothing, 0.0) * maxf(delta, 0.0))


## Offset kamera dari fokus: yaw memutar di sekitar sumbu Y, pitch = sudut pandang ke bawah.
static func compute_offset(distance: float, pitch_deg: float, yaw_deg_: float) -> Vector3:
	var pitch := deg_to_rad(pitch_deg)
	var yaw := deg_to_rad(yaw_deg_)
	var horizontal := distance * cos(pitch)
	return Vector3(sin(yaw) * horizontal, distance * sin(pitch), cos(yaw) * horizontal)


static func compute_pose(focus: Vector3, yaw_deg_: float, pitch_deg: float, distance: float) -> Transform3D:
	var offset := compute_offset(distance, pitch_deg, yaw_deg_)
	return Transform3D(Basis.IDENTITY, focus + offset).looking_at(focus, Vector3.UP)
