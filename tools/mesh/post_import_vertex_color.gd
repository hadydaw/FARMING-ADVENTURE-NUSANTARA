@tool
extends EditorScenePostImport
## Skrip pasca-impor untuk model hasil mesh-lewat-kode: mengaktifkan warna vertex
## sebagai albedo (importer glTF tidak mengaktifkannya sendiri). Hanya dipakai editor
## saat impor; tidak ikut ekspor game (lihat exclude_filter di export_presets.cfg).

func _post_import(scene: Node) -> Object:
	for node in scene.find_children("*", "MeshInstance3D", true, true):
		var mesh := (node as MeshInstance3D).mesh
		if mesh == null:
			continue
		for i in mesh.get_surface_count():
			var mat := mesh.surface_get_material(i) as StandardMaterial3D
			if mat != null:
				mat.vertex_color_use_as_albedo = true
				mat.roughness = 1.0
				mat.metallic_specular = 0.0
	return scene
