class_name PlayerController
extends CharacterBody3D
## Pengendali pemain: bergerak relatif kamera dari joystick/keyboard, menghadap arah
## gerak, bertabrakan dengan dunia. Tidak berisi visual; tampilan dipasang sebagai anak
## (model pemain final menunggu B-001 dari ChatGPT).

signal facing_changed(direction: Vector3)

## Nilai teknis sementara (kecepatan dan percepatan belum diputuskan sebagai desain).
@export var move_speed: float = 4.0
@export var acceleration: float = 24.0
@export var turn_speed_deg: float = 540.0

var camera_yaw_deg: float = 0.0
var facing: Vector3 = Vector3(0, 0, -1)
var yaw_deg: float = 0.0
## Vektor input 2D; bila null, dibaca dari InputService.
var input_override: Variant = null


func _ready() -> void:
	motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.35
	capsule.height = 1.6
	shape.shape = capsule
	shape.position = Vector3(0, 0.8, 0)
	add_child(shape)


func _physics_process(delta: float) -> void:
	var input: Vector2 = InputService.move_vector() if input_override == null else (input_override as Vector2)
	step(input, delta)


## Satu langkah gerak (dipisah agar dapat diuji).
func step(input: Vector2, delta: float) -> void:
	var wish := MovementMath.camera_relative(input, camera_yaw_deg) * move_speed
	var horizontal := MovementMath.approach(Vector3(velocity.x, 0, velocity.z), wish, acceleration, delta)
	velocity = Vector3(horizontal.x, 0, horizontal.z)
	move_and_slide()
	position.y = 0.0
	if wish.length_squared() > 0.0001:
		var target_yaw := MovementMath.facing_yaw_deg(wish, yaw_deg)
		yaw_deg = rotate_toward(deg_to_rad(yaw_deg), deg_to_rad(target_yaw), deg_to_rad(turn_speed_deg) * delta)
		yaw_deg = rad_to_deg(yaw_deg)
		facing = Vector3(-sin(deg_to_rad(yaw_deg)), 0, -cos(deg_to_rad(yaw_deg)))
		facing_changed.emit(facing)
