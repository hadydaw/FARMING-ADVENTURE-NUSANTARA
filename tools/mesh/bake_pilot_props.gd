extends SceneTree
## Membangun mesh pilot lalu menyimpan sebagai .glb di game/assets/models/pilot/.
##   godot --headless --path . --script res://tools/mesh/bake_pilot_props.gd
## Setelah itu jalankan: godot --headless --path . --import

const OUT_DIR := "res://game/assets/models/pilot"


func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT_DIR))
	var failed := 0
	for id in PilotProps.PROP_IDS:
		var builder := PilotProps.build(id, 1)
		var root := Node3D.new()
		root.name = "pilot_" + id
		var mi := MeshInstance3D.new()
		mi.name = "mesh"
		mi.mesh = builder.build(PilotProps.material_for(id))
		root.add_child(mi)
		var doc := GLTFDocument.new()
		var state := GLTFState.new()
		var err := doc.append_from_scene(root, state)
		if err == OK:
			err = doc.write_to_filesystem(state, "%s/pilot_%s.glb" % [OUT_DIR, id])
		var box := builder.bounds()
		print("%s: %d segitiga, ukuran %s, galat=%d" % [id, builder.triangle_count(), str(box.size), err])
		if err != OK:
			failed += 1
		root.free()
	quit(1 if failed > 0 else 0)
