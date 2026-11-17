extends TestCase

func _tri_data(mesh: ArrayMesh) -> Dictionary:
	var arrays := mesh.surface_get_arrays(0)
	return {"v": arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array, "n": arrays[Mesh.ARRAY_NORMAL] as PackedVector3Array}


func run() -> void:
	# Segitiga merosot dibuang
	var b := MeshBuilder.new()
	b.add_tri(Vector3.ZERO, Vector3.ZERO, Vector3.ONE, Color.WHITE)
	check_eq(b.triangle_count(), 0, "segitiga merosot dibuang")
	b.add_tri(Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Color.WHITE)
	check_eq(b.triangle_count(), 1, "segitiga valid diterima")
	b.double_sided = true
	b.add_tri(Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Color.WHITE)
	check_eq(b.triangle_count(), 3, "mode dua sisi menambah sisi belakang")

	# Arah normal keluar dan urutan searah jarum jam (sisi depan Godot) untuk tiap bentuk
	var shapes := {
		"blob": func(m: MeshBuilder): m.add_blob(Vector3.ZERO, Vector3.ONE, 1, 0.2, 3, func(_n, _d): return Color.WHITE),
		"lathe": func(m: MeshBuilder): m.add_lathe([Vector2(0.5, 0), Vector2(0.4, 1.0)], 6, func(_y, _a): return Color.WHITE, 0.0, 1, true, true),
		"tube": func(m: MeshBuilder): m.add_tube([Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(0, 2, 0)], [0.3, 0.3, 0.3], 6, func(_t, _a): return Color.WHITE),
	}
	for key in shapes:
		var m := MeshBuilder.new()
		(shapes[key] as Callable).call(m)
		var d := _tri_data(m.build())
		var v: PackedVector3Array = d["v"]
		var n: PackedVector3Array = d["n"]
		var center := m.bounds().get_center()
		var outward := 0
		var clockwise := 0
		var tris := v.size() / 3
		for i in tris:
			var a := v[i * 3]
			var bb := v[i * 3 + 1]
			var c := v[i * 3 + 2]
			var centroid := (a + bb + c) / 3.0
			if n[i * 3].dot(centroid - center) > -0.001:
				outward += 1
			if (bb - a).cross(c - a).dot(n[i * 3]) < 0.0:
				clockwise += 1
		check_eq(clockwise, tris, "%s: semua sisi depan searah jarum jam (Godot)" % key)
		check(outward >= tris - 2, "%s: normal menghadap keluar (%d/%d)" % [key, outward, tris])

	# Determinisme dan variasi seed
	for id in PilotProps.PROP_IDS:
		var a := PilotProps.build(id, 1)
		var a2 := PilotProps.build(id, 1)
		var c := PilotProps.build(id, 2)
		check_eq(a.fingerprint(), a2.fingerprint(), "%s: seed sama = mesh sama" % id)
		if true:
			check(a.fingerprint() != c.fingerprint() or id == "fence", "%s: seed beda = variasi" % id)

	# Anggaran (TA §3: objek dunia <= 1000 segitiga) dan ukuran yang masuk akal (B-003)
	var limits := {
		"tree_a": [3.8, 6.5], "tree_b": [4.0, 6.5], "rock_a": [0.5, 1.6], "rock_b": [0.5, 1.6],
		"fence": [0.9, 1.2], "bush": [0.5, 1.2], "tuft": [0.2, 0.5],
	}
	for id in PilotProps.PROP_IDS:
		var pb := PilotProps.build(id, 1)
		check(pb.triangle_count() > 0 and pb.triangle_count() <= 1000, "%s: %d segitiga <= 1000" % [id, pb.triangle_count()])
		var box := pb.bounds()
		var h := box.size.y
		check(h >= float(limits[id][0]) and h <= float(limits[id][1]), "%s: tinggi %.2f m dalam rentang B-003" % [id, h])
		var mesh := pb.build()
		var ok := true
		for vtx in (mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX] as PackedVector3Array):
			if is_nan(vtx.x) or is_nan(vtx.y) or is_nan(vtx.z):
				ok = false
		check(ok, "%s: tanpa NaN" % id)

	# Hasil bake .glb termuat dengan warna vertex aktif dan jumlah segitiga sama
	for id in PilotProps.PROP_IDS:
		var scene := load("res://game/assets/models/pilot/pilot_%s.glb" % id) as PackedScene
		check(scene != null, "%s: .glb termuat" % id)
		if scene == null:
			continue
		var node := scene.instantiate()
		var meshes := node.find_children("*", "MeshInstance3D", true, false)
		check_eq(meshes.size(), 1, "%s: satu MeshInstance3D" % id)
		if meshes.size() == 1:
			var mesh := (meshes[0] as MeshInstance3D).mesh
			var mat := mesh.surface_get_material(0) as StandardMaterial3D
			check(mat != null and mat.vertex_color_use_as_albedo, "%s: warna vertex aktif (skrip pasca-impor)" % id)
			var tris := (mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX] as PackedVector3Array).size() / 3
			check_eq(tris, PilotProps.build(id, 1).triangle_count(), "%s: jumlah segitiga sama dengan generator" % id)
		node.free()

	# Scene pilot dapat dibuka
	await SceneManager.go("mesh_pilot", true, false)
	await wait_frames(3)
	check_eq(tree.current_scene.name, "MeshPilot", "scene pilot mesh aktif")
	check(tree.current_scene.info_text().contains("tree_a"), "info prop tampil")
	tree.current_scene._focus(3)
	check_eq(tree.current_scene.focus_index(), 3, "pindah fokus prop")
	await SceneManager.go("main_menu", false, false)
