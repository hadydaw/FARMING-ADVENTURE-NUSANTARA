extends TestCase

func run() -> void:
	# Data valid
	var props: Array = DataRegistry.rows("world_props")
	var layout: Array = DataRegistry.rows("world_start_layout")
	check(props.size() == 7, "7 definisi prop")
	check(layout.size() >= 40, "tata letak berisi penempatan (%d)" % layout.size())
	var bad := 0
	for row in layout:
		if not DataRegistry.has_row("world_props", str(row["prop"])):
			bad += 1
		if absf(float(row["x"])) > 29.0 or absf(float(row["z"])) > 29.0:
			bad += 1
		if Vector2(float(row["x"]), float(row["z"])).length() < 3.0 and str(row["prop"]) != "tuft":
			bad += 1
	check_eq(bad, 0, "penempatan valid, di dalam dunia, tidak menimpa titik mulai")
	for p in props:
		check(ResourceLoader.exists(str(p["model"])), "model ada: %s" % p["id"])
		check(bool(p.get("provisional", false)), "prop ditandai sementara: %s" % p["id"])

	GameTime.new_game()
	await SceneManager.go("world_start", true, false)
	await wait_frames(3)
	var world: Node = tree.current_scene
	check_eq(world.name, "WorldStart", "dunia awal aktif")
	check_eq(world.prop_count, layout.size(), "semua prop terpasang")
	check(world.hud.time_text().contains("06:"), "HUD menampilkan waktu awal")

	# Pemain bergerak (physics) dan kamera mengikuti
	var player: PlayerController = world.player
	player.input_override = Vector2(0, -1)
	var z0 := player.global_position.z
	for i in 40:
		await tree.physics_frame
	check(player.global_position.z < z0 - 0.5, "pemain maju ke -Z")
	check(absf(player.global_position.y) < 0.01, "pemain tetap di tanah")
	player.input_override = Vector2.ZERO
	for i in 30:
		await tree.physics_frame
	check(player.velocity.length() < 0.05, "pemain berhenti tanpa input")

	# Tabrakan: pohon menghalangi
	var tree_row: Dictionary = {}
	for row in layout:
		if str(row["prop"]) == "tree_a":
			tree_row = row
			break
	var tpos := Vector3(float(tree_row["x"]), 0, float(tree_row["z"]))
	player.global_position = tpos + Vector3(0, 0, 3.0)
	player.velocity = Vector3.ZERO
	player.camera_yaw_deg = 0.0
	player.input_override = Vector2.ZERO
	await tree.physics_frame
	# arahkan langsung ke pohon: input relatif kamera yaw 0, maju = -Z
	var dir := (tpos - player.global_position)
	# yaw kamera diatur agar "maju" mengarah ke pohon
	player.camera_yaw_deg = -rad_to_deg(atan2(-dir.x, -dir.z))
	player.input_override = Vector2(0, -1)
	for i in 120:
		await tree.physics_frame
	var dist := Vector2(player.global_position.x - tpos.x, player.global_position.z - tpos.z).length()
	check(dist > 0.45, "pemain tidak menembus batang pohon (jarak %.2f)" % dist)
	check(dist < 2.0, "pemain mendekati pohon (jarak %.2f)" % dist)

	# Interaksi dengan pohon
	player.input_override = Vector2.ZERO
	await wait_frames(3)
	world.sensor.facing = (tpos - player.global_position).normalized()
	check(world.sensor.refresh() != null, "pohon terdeteksi sebagai target")
	check(world.sensor.try_interact(), "interaksi dengan pohon")
	check_eq(world.inspect_count(), 1, "interaksi tercatat")

	# Batas dunia
	player.global_position = Vector3(28, 0, 0)
	player.input_override = Vector2(1, 0)  # kanan relatif yaw 0 = +X (menuju batas)
	player.camera_yaw_deg = 0.0
	for i in 120:
		await tree.physics_frame
	check(player.global_position.x < 30.1, "pemain tidak keluar dari dunia (x=%.2f)" % player.global_position.x)
	player.input_override = null

	# Tata letak HUD
	var vp := tree.root.get_visible_rect()
	check(vp.encloses(world.hud.joystick().get_global_rect()), "joystick HUD di dalam layar")
	check(vp.encloses(world.hud.interact_button().get_global_rect()), "tombol interaksi HUD di dalam layar")

	await SceneManager.go("main_menu", false, false)
	GameTime.new_game()
