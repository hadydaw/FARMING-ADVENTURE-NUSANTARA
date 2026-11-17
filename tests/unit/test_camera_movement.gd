extends TestCase

func run() -> void:
	# Offset kamera
	var o := CameraRig.compute_offset(10.0, 0.0, 0.0)
	check_near(o.x, 0.0, "yaw 0: x=0")
	check_near(o.y, 0.0, "pitch 0: y=0")
	check_near(o.z, 10.0, "yaw 0: kamera di +Z")
	o = CameraRig.compute_offset(10.0, 90.0, 0.0)
	check_near(o.y, 10.0, "pitch 90: tepat di atas")
	o = CameraRig.compute_offset(10.0, 30.0, 90.0)
	check_near(o.length(), 10.0, "panjang offset = jarak")
	check(o.x > 0.0, "yaw 90: kamera ke +X")

	# Pose menghadap fokus
	var focus := Vector3(3, 0, -2)
	var pose := CameraRig.compute_pose(focus, 30.0, 45.0, 8.0)
	var forward := -pose.basis.z
	var to_focus := (focus - pose.origin).normalized()
	check(forward.dot(to_focus) > 0.9999, "kamera menghadap fokus")

	# Penghalusan tak bergantung frame rate
	var one := CameraRig.smooth_factor(8.0, 1.0 / 30.0)
	var two := 1.0 - pow(1.0 - CameraRig.smooth_factor(8.0, 1.0 / 60.0), 2.0)
	check_near(one, two, "dua langkah 60fps = satu langkah 30fps", 0.0001)
	check_near(CameraRig.smooth_factor(8.0, 0.0), 0.0, "delta 0 tidak bergerak")

	# Rig dengan data nyata
	var rig := CameraRig.new()
	rig.configure_from_registry()
	check(rig.has_profile("farming") and rig.has_profile("exploration") and rig.has_profile("interaction"), "3 profil konteks ada")
	check(not rig.set_profile("tidak_ada"), "profil tak dikenal ditolak")
	check(rig.set_profile("farming", true), "set profil instan")
	check_eq(rig.profile_id, "farming", "profil aktif")
	var far_dist := rig.camera().position.distance_to(rig.target_position)
	rig.set_profile("interaction")
	for i in 120:
		rig.step(1.0 / 60.0)
	var near_dist := rig.camera().position.distance_to(rig.target_position)
	check(near_dist < far_dist, "profil interaksi lebih dekat dari farming")
	check_near(rig.camera().fov, 40.0, "fov mencapai profil interaksi", 0.1)

	# Mengikuti target dengan halus (tidak melompat)
	rig.target_position = Vector3(10, 0, 0)
	rig.step(1.0 / 60.0)
	check(rig.camera().position.x < 5.0, "kamera tidak melompat ke target sekaligus")
	for i in 300:
		rig.step(1.0 / 60.0)
	check_near(rig.camera().position.x, 10.0, "kamera akhirnya menyusul target", 0.2)

	# Batas zoom dan rotasi
	for i in 50:
		rig.zoom_by(1.5)
	check_near(rig.zoom, rig.zoom_max(), "zoom dibatasi maksimum")
	for i in 50:
		rig.zoom_by(0.5)
	check_near(rig.zoom, rig.zoom_min(), "zoom dibatasi minimum")
	rig.rotate_by(1000.0)
	check_near(rig.yaw_deg, 180.0, "yaw dibatasi")
	rig.free()

	# Gerak relatif kamera
	var v := MovementMath.camera_relative(Vector2(0, -1), 0.0)
	check_near(v.z, -1.0, "maju di yaw 0 = -Z")
	v = MovementMath.camera_relative(Vector2(1, 0), 0.0)
	check_near(v.x, 1.0, "kanan di yaw 0 = +X")
	v = MovementMath.camera_relative(Vector2(0, -1), 90.0)
	check_near(v.x, -1.0, "maju di yaw 90 = -X")
	check_eq(MovementMath.camera_relative(Vector2.ZERO, 33.0), Vector3.ZERO, "tanpa input = diam")
	check_near(MovementMath.camera_relative(Vector2(3, -3), 10.0).length(), 1.0, "panjang dibatasi 1")
	var a := MovementMath.approach(Vector3.ZERO, Vector3(10, 0, 0), 5.0, 0.5)
	check_near(a.x, 2.5, "percepatan terbatas")
	check_near(MovementMath.facing_yaw_deg(Vector3(0, 0, -1), 77.0), 0.0, "hadap -Z = yaw 0")
	check_near(MovementMath.facing_yaw_deg(Vector3.ZERO, 77.0), 77.0, "tanpa arah mempertahankan yaw")
