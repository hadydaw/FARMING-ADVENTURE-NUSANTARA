class_name MovementMath
extends RefCounted
## Matematika gerak murni (tanpa node) untuk kontrol karakter.

## Mengubah input 2D (x kanan, y bawah, seperti joystick) menjadi arah gerak di bidang
## tanah relatif terhadap arah kamera (yaw dalam derajat; yaw 0 = kamera di +Z menghadap -Z).
static func camera_relative(input: Vector2, camera_yaw_deg: float) -> Vector3:
	if input.length_squared() < 0.000001:
		return Vector3.ZERO
	var v := input.limit_length(1.0)
	var yaw := deg_to_rad(camera_yaw_deg)
	var forward := Vector3(-sin(yaw), 0.0, -cos(yaw))
	var right := Vector3(cos(yaw), 0.0, -sin(yaw))
	return (right * v.x + forward * -v.y)


## Kecepatan terhaluskan menuju kecepatan target (percepatan terbatas).
static func approach(current: Vector3, target: Vector3, acceleration: float, delta: float) -> Vector3:
	return current.move_toward(target, maxf(acceleration, 0.0) * maxf(delta, 0.0))


## Yaw (derajat) agar karakter menghadap arah gerak; arah nol mempertahankan yaw lama.
static func facing_yaw_deg(direction: Vector3, current_yaw_deg: float) -> float:
	var flat := Vector3(direction.x, 0.0, direction.z)
	if flat.length_squared() < 0.000001:
		return current_yaw_deg
	return rad_to_deg(atan2(-flat.x, -flat.z))
