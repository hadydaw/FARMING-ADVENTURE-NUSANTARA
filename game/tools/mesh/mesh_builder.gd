class_name MeshBuilder
extends RefCounted
## Pembangun mesh kustom lewat kode (Opsi A, produksi model 3D).
##
## Menyusun segitiga datar (flat shading, vertex tidak dibagi) dengan warna per-vertex,
## untuk gaya 3D Stylized poli rendah. Bentuk: lathe (profil putar), blob (ikosfer
## ber-noise), tabung sapuan (path + jari-jari), bilah lengkung, dan segitiga/segiempat
## bebas. Semua dapat ditransformasi (`xf`) agar bagian dapat dirakit.
##
## Pembangun ini HANYA alat konstruksi. Bentuk akhir wajib mengikuti gambar acuan
## ChatGPT; generator pilot yang memakainya berlabel pilot dan bukan aset final.

var xf: Transform3D = Transform3D.IDENTITY
var double_sided: bool = false

var _vertices := PackedVector3Array()
var _normals := PackedVector3Array()
var _colors := PackedColorArray()


func triangle_count() -> int:
	return _vertices.size() / 3


func is_empty() -> bool:
	return _vertices.is_empty()


## Segitiga datar dengan satu warna per segitiga. Input berurutan CCW (aturan tangan kanan,
## normal keluar). Godot memakai sisi depan searah jarum jam, jadi urutan keluaran dibalik.
func add_tri(a: Vector3, b: Vector3, c: Vector3, color: Color) -> void:
	var pa := xf * a
	var pb := xf * b
	var pc := xf * c
	var n := (pb - pa).cross(pc - pa)
	if n.length_squared() < 1e-12:
		return  # segitiga merosot dibuang
	n = n.normalized()
	for p in [pa, pc, pb]:
		_vertices.append(p)
		_normals.append(n)
		_colors.append(color)
	if double_sided:
		for p in [pa, pb, pc]:
			_vertices.append(p)
			_normals.append(-n)
			_colors.append(color)


func add_quad(a: Vector3, b: Vector3, c: Vector3, d: Vector3, color: Color) -> void:
	add_tri(a, b, c, color)
	add_tri(a, c, d, color)


## Mesh putar dari profil [(jari-jari, y), ...] dari bawah ke atas.
## `radial_jitter` menggeser tiap titik cincin secara deterministik (bentuk tidak kaku),
## `color_fn(y_norm, angle) -> Color` memberi warna per sisi. Tutup atas/bawah opsional.
func add_lathe(profile: Array, segments: int, color_fn: Callable, radial_jitter: float = 0.0, seed_value: int = 1, cap_top: bool = true, cap_bottom: bool = false, angle_offset: float = 0.0) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var rings: Array = []
	for i in profile.size():
		var r: float = profile[i].x
		var y: float = profile[i].y
		var ring: Array[Vector3] = []
		for s in segments:
			var a := angle_offset + TAU * float(s) / float(segments)
			var rr := r * (1.0 + rng.randf_range(-radial_jitter, radial_jitter))
			ring.append(Vector3(cos(a) * rr, y, sin(a) * rr))
		rings.append(ring)
	var y_min: float = profile[0].y
	var y_span: float = maxf(float(profile[profile.size() - 1].y) - y_min, 0.0001)
	for i in range(profile.size() - 1):
		var lo: Array = rings[i]
		var hi: Array = rings[i + 1]
		for s in segments:
			var n := (s + 1) % segments
			var yn: float = (float(profile[i].y) + float(profile[i + 1].y)) * 0.5
			var col: Color = color_fn.call((yn - y_min) / y_span, angle_offset + TAU * (float(s) + 0.5) / float(segments))
			add_quad(lo[s], hi[s], hi[n], lo[n], col)
	if cap_top:
		var top: Array = rings[rings.size() - 1]
		var center := Vector3(0, float(profile[profile.size() - 1].y), 0)
		for s in segments:
			add_tri(center, top[(s + 1) % segments], top[s], color_fn.call(1.0, 0.0))
	if cap_bottom:
		var bottom: Array = rings[0]
		var c0 := Vector3(0, float(profile[0].y), 0)
		for s in segments:
			add_tri(c0, bottom[s], bottom[(s + 1) % segments], color_fn.call(0.0, 0.0))


## Ikosfer terbagi (detail 0 = 20 segitiga, 1 = 80, 2 = 320) dengan skala per sumbu dan
## perpindahan noise berdasarkan arah (titik bersama tetap menyatu, tanpa retak).
## `color_fn(normal, centroid_dir) -> Color` dipanggil per segitiga.
func add_blob(center: Vector3, radii: Vector3, detail: int, noise_amp: float, seed_value: int, color_fn: Callable, noise_freq: float = 1.6) -> void:
	var noise := FastNoiseLite.new()
	noise.seed = seed_value
	noise.frequency = 1.0
	var mesh_data := _icosphere(detail)
	var verts: Array = mesh_data["verts"]
	var faces: Array = mesh_data["faces"]
	var displaced: Array[Vector3] = []
	for v in verts:
		var d: Vector3 = v
		var n := noise.get_noise_3dv(d * noise_freq)
		var scale := 1.0 + n * noise_amp
		displaced.append(center + Vector3(d.x * radii.x, d.y * radii.y, d.z * radii.z) * scale)
	for f in faces:
		var a: Vector3 = displaced[f[0]]
		var b: Vector3 = displaced[f[1]]
		var c: Vector3 = displaced[f[2]]
		var nrm := (b - a).cross(c - a).normalized()
		var dir := ((a + b + c) / 3.0 - center).normalized()
		add_tri(a, b, c, color_fn.call(nrm, dir))


## Tabung sapuan sepanjang jalur dengan jari-jari berbeda tiap titik (batang, dahan, rel).
func add_tube(points: Array, radii: Array, sides: int, color_fn: Callable, cap_end: bool = true, twist: float = 0.0) -> void:
	var rings: Array = []
	var up_hint := Vector3.UP
	for i in points.size():
		var p: Vector3 = points[i]
		var tangent: Vector3
		if i == 0:
			tangent = (points[1] - points[0])
		elif i == points.size() - 1:
			tangent = (points[i] - points[i - 1])
		else:
			tangent = (points[i + 1] - points[i - 1])
		tangent = tangent.normalized()
		var side := tangent.cross(up_hint)
		if side.length_squared() < 0.0001:
			side = tangent.cross(Vector3.RIGHT)
		side = side.normalized()
		var bin := tangent.cross(side).normalized()
		var ring: Array[Vector3] = []
		for s in sides:
			var a := TAU * float(s) / float(sides) + twist * float(i)
			ring.append(p + (side * cos(a) + bin * sin(a)) * float(radii[i]))
		rings.append(ring)
	for i in range(points.size() - 1):
		for s in sides:
			var n := (s + 1) % sides
			var t := (float(i) + 0.5) / float(points.size() - 1)
			add_quad(rings[i][s], rings[i][n], rings[i + 1][n], rings[i + 1][s], color_fn.call(t, TAU * (float(s) + 0.5) / float(sides)))
	if cap_end:
		var last: Array = rings[rings.size() - 1]
		var c: Vector3 = points[points.size() - 1]
		for s in sides:
			add_tri(c, last[s], last[(s + 1) % sides], color_fn.call(1.0, 0.0))


## Bilah rumput melengkung: pita meruncing dari pangkal ke ujung.
func add_blade(base: Vector3, height: float, width: float, bend: Vector3, segments: int, color_base: Color, color_tip: Color, facing_deg: float = 0.0) -> void:
	var side := Vector3(cos(deg_to_rad(facing_deg)), 0, sin(deg_to_rad(facing_deg)))
	var prev_l := base - side * width * 0.5
	var prev_r := base + side * width * 0.5
	for i in range(1, segments + 1):
		var t := float(i) / float(segments)
		var w := width * (1.0 - t * t * 0.95) * 0.5
		var p := base + Vector3(0, height * t, 0) + bend * (t * t)
		var l := p - side * w
		var r := p + side * w
		var col := color_base.lerp(color_tip, t)
		if i == segments:
			add_tri(prev_l, prev_r, p, col)
		else:
			add_quad(prev_l, prev_r, r, l, col)
		prev_l = l
		prev_r = r


## Menghasilkan ArrayMesh dengan normal datar dan warna vertex.
func build(material: Material = null) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	if _vertices.is_empty():
		return mesh
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = _vertices
	arrays[Mesh.ARRAY_NORMAL] = _normals
	arrays[Mesh.ARRAY_COLOR] = _colors
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	if material != null:
		mesh.surface_set_material(0, material)
	return mesh


func bounds() -> AABB:
	if _vertices.is_empty():
		return AABB()
	var box := AABB(_vertices[0], Vector3.ZERO)
	for v in _vertices:
		box = box.expand(v)
	return box


## Hash isi mesh untuk uji determinisme.
func fingerprint() -> int:
	var h: int = 17
	for v in _vertices:
		h = h * 31 + int(roundf(v.x * 1000.0))
		h = h * 31 + int(roundf(v.y * 1000.0))
		h = h * 31 + int(roundf(v.z * 1000.0))
	return h


# --- internal ---

static func _icosphere(detail: int) -> Dictionary:
	var t := (1.0 + sqrt(5.0)) / 2.0
	var verts: Array[Vector3] = [
		Vector3(-1, t, 0), Vector3(1, t, 0), Vector3(-1, -t, 0), Vector3(1, -t, 0),
		Vector3(0, -1, t), Vector3(0, 1, t), Vector3(0, -1, -t), Vector3(0, 1, -t),
		Vector3(t, 0, -1), Vector3(t, 0, 1), Vector3(-t, 0, -1), Vector3(-t, 0, 1),
	]
	for i in verts.size():
		verts[i] = verts[i].normalized()
	var faces: Array = [
		[0, 11, 5], [0, 5, 1], [0, 1, 7], [0, 7, 10], [0, 10, 11],
		[1, 5, 9], [5, 11, 4], [11, 10, 2], [10, 7, 6], [7, 1, 8],
		[3, 9, 4], [3, 4, 2], [3, 2, 6], [3, 6, 8], [3, 8, 9],
		[4, 9, 5], [2, 4, 11], [6, 2, 10], [8, 6, 7], [9, 8, 1],
	]
	for _i in detail:
		var cache := {}
		var next_faces: Array = []
		for f in faces:
			var m01 := _midpoint(verts, cache, f[0], f[1])
			var m12 := _midpoint(verts, cache, f[1], f[2])
			var m20 := _midpoint(verts, cache, f[2], f[0])
			next_faces.append([f[0], m01, m20])
			next_faces.append([f[1], m12, m01])
			next_faces.append([f[2], m20, m12])
			next_faces.append([m01, m12, m20])
		faces = next_faces
	return {"verts": verts, "faces": faces}


static func _midpoint(verts: Array[Vector3], cache: Dictionary, a: int, b: int) -> int:
	var key := (mini(a, b) << 20) | maxi(a, b)
	if cache.has(key):
		return cache[key]
	verts.append(((verts[a] + verts[b]) * 0.5).normalized())
	cache[key] = verts.size() - 1
	return verts.size() - 1
