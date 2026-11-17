class_name PilotProps
extends RefCounted
## PILOT TEKNIS Opsi A (O-010): generator props B-003 untuk menguji metode mesh lewat kode.
##
## BUKAN aset final dan BUKAN desain resmi. Belum ada gambar acuan B-003 dari ChatGPT,
## jadi siluet, warna, dan proporsi di sini hanya bentuk generik untuk mengukur batas
## metode (anggaran poligon, kualitas bentuk, waktu konstruksi). Saat acuan disetujui,
## bentuk dibangun ulang mengikuti acuan dan pilot ini dihapus.
## Warna memakai vertex color karena tekstur seamless B-003 belum disediakan.

const PROP_IDS := ["tree_a", "tree_b", "rock_a", "rock_b", "fence", "bush", "tuft"]


static func build(prop_id: String, seed_value: int = 1) -> MeshBuilder:
	match prop_id:
		"tree_a": return tree_a(seed_value)
		"tree_b": return tree_b(seed_value)
		"rock_a": return rock_a(seed_value)
		"rock_b": return rock_b(seed_value)
		"fence": return fence(seed_value)
		"bush": return bush(seed_value)
		"tuft": return tuft(seed_value)
	return null


static func material_for(prop_id: String) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.vertex_color_use_as_albedo = true
	m.roughness = 1.0
	m.metallic_specular = 0.0
	if prop_id == "tuft":
		m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m


# --- Pohon A: tajuk membulat berbonggol, batang melebar di akar, dahan ---
static func tree_a(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var bark := func(y: float, ang: float) -> Color:
		var stripe := 0.5 + 0.5 * sin(ang * 5.0 + y * 3.0)
		return Color(0.33, 0.22, 0.14).lerp(Color(0.46, 0.32, 0.20), stripe * 0.6 + y * 0.3)
	b.add_lathe([Vector2(0.62, 0.0), Vector2(0.42, 0.25), Vector2(0.30, 0.9), Vector2(0.26, 1.8), Vector2(0.22, 2.6), Vector2(0.20, 3.2)],
		7, bark, 0.06, seed_value, true, true)
	# Dahan menuju tajuk
	var branch_color := func(t: float, _a: float) -> Color:
		return Color(0.36, 0.25, 0.16).lerp(Color(0.44, 0.31, 0.2), t)
	for i in 3:
		var yaw := TAU * (float(i) / 3.0) + rng.randf_range(-0.3, 0.3)
		var dir := Vector3(cos(yaw), 0.0, sin(yaw))
		b.add_tube([Vector3(0, 2.4 + i * 0.25, 0), Vector3(0, 2.9 + i * 0.25, 0) + dir * 0.45, Vector3(0, 3.5 + i * 0.25, 0) + dir * 0.95],
			[0.14, 0.10, 0.06], 5, branch_color)
	# Tajuk: gugus bonggol, gelap di bawah, terang di atas, variasi per muka
	var leaf := func(nrm: Vector3, dir: Vector3) -> Color:
		var h := clampf(dir.y * 0.5 + 0.5, 0.0, 1.0)
		var base := Color(0.17, 0.36, 0.17).lerp(Color(0.46, 0.68, 0.24), h * 0.9)
		var j := rng.randf_range(-0.04, 0.04)
		var lit := clampf(nrm.dot(Vector3(0.4, 0.8, 0.3).normalized()) * 0.5 + 0.5, 0.0, 1.0)
		return Color(base.r + j, base.g + j, base.b + j * 0.5).lightened(lit * 0.12)
	var blobs := [
		[Vector3(0, 4.4, 0), Vector3(1.7, 1.25, 1.7)],
		[Vector3(1.15, 3.8, 0.3), Vector3(1.15, 0.95, 1.1)],
		[Vector3(-1.0, 3.9, -0.6), Vector3(1.2, 0.95, 1.1)],
		[Vector3(0.1, 3.7, -1.2), Vector3(1.05, 0.85, 1.05)],
		[Vector3(-0.3, 5.1, 0.4), Vector3(1.05, 0.8, 1.05)],
	]
	for i in blobs.size():
		b.add_blob(blobs[i][0], blobs[i][1], 1, 0.32, seed_value * 7 + i, leaf)
	return b


# --- Pohon B: tegak, tingkat daun runcing bergerigi ---
static func tree_b(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var bark := func(y: float, ang: float) -> Color:
		return Color(0.30, 0.20, 0.13).lerp(Color(0.40, 0.28, 0.18), 0.5 + 0.5 * sin(ang * 4.0 + y * 5.0))
	b.add_lathe([Vector2(0.50, 0.0), Vector2(0.30, 0.3), Vector2(0.22, 1.2), Vector2(0.17, 2.0)], 6, bark, 0.05, seed_value, true, true)
	var tiers := [
		[1.1, 2.0, 1.75, 1.1],   # [y_dasar, tinggi, radius, jitter]
		[2.1, 1.9, 1.40, 0.9],
		[3.1, 1.8, 1.05, 0.75],
		[4.0, 1.7, 0.72, 0.6],
	]
	for i in tiers.size():
		var t: Array = tiers[i]
		var base_y: float = t[0]
		var h: float = t[1]
		var r: float = t[2]
		var shade := func(y_norm: float, ang: float) -> Color:
			var zig := 0.5 + 0.5 * sin(ang * 8.0)
			return Color(0.10, 0.28, 0.20).lerp(Color(0.24, 0.52, 0.28), y_norm * 0.8 + zig * 0.1 + float(i) * 0.04)
		# Rok bergerigi: dua cincin bawah berselang-seling jari-jari
		var profile := [Vector2(r * 0.55, base_y), Vector2(r, base_y + h * 0.15), Vector2(r * 0.55, base_y + h * 0.5), Vector2(0.06, base_y + h)]
		b.add_lathe(profile, 8, shade, 0.22, seed_value * 13 + i, false, true, float(i) * 0.4)
	return b


# --- Batu A: bulat-menyudut, lumut di atas ---
static func rock_a(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var stone := func(nrm: Vector3, _d: Vector3) -> Color:
		var g := 0.46 + rng.randf_range(-0.05, 0.05)
		var base := Color(g, g * 0.98, g * 0.94)
		var moss := clampf((nrm.y - 0.55) * 2.2, 0.0, 1.0)
		return base.lerp(Color(0.30, 0.46, 0.22), moss * 0.7)
	b.add_blob(Vector3(0, 0.38, 0), Vector3(0.78, 0.5, 0.66), 2, 0.4, seed_value, stone, 1.9)
	b.add_blob(Vector3(0.55, 0.2, 0.2), Vector3(0.38, 0.28, 0.34), 1, 0.4, seed_value + 5, stone, 2.2)
	return b


# --- Batu B: memanjang, bidang datar di bawah, retakan bertingkat ---
static func rock_b(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var stone := func(nrm: Vector3, _d: Vector3) -> Color:
		var g := 0.40 + rng.randf_range(-0.04, 0.04) + nrm.y * 0.06
		return Color(g * 0.96, g, g * 1.04)
	b.add_blob(Vector3(0, 0.45, 0), Vector3(0.55, 0.62, 0.45), 2, 0.45, seed_value + 3, stone, 2.4)
	b.add_blob(Vector3(-0.5, 0.25, 0.1), Vector3(0.45, 0.4, 0.42), 1, 0.5, seed_value + 9, stone, 2.0)
	b.add_blob(Vector3(0.45, 0.18, -0.2), Vector3(0.35, 0.25, 0.3), 1, 0.45, seed_value + 11, stone, 2.0)
	return b


# --- Pagar kayu: dua tiang berujung runcing, dua rel miring, penyangga ---
static func fence(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var wood := func(y_norm: float, ang: float) -> Color:
		var grain := 0.5 + 0.5 * sin(ang * 3.0 + y_norm * 9.0 + rng.randf() * 0.4)
		return Color(0.44, 0.30, 0.18).lerp(Color(0.58, 0.42, 0.26), grain * 0.5 + y_norm * 0.2)
	for i in 2:
		var x := -0.95 + float(i) * 1.9
		var lean := rng.randf_range(-0.03, 0.03)
		b.xf = Transform3D(Basis(Vector3(0, 0, 1), lean), Vector3(x, 0, 0))
		b.add_lathe([Vector2(0.11, 0.0), Vector2(0.10, 0.9), Vector2(0.11, 1.0), Vector2(0.03, 1.08)], 4, wood, 0.06, seed_value + i, true, true, PI / 4.0)
	b.xf = Transform3D.IDENTITY
	for i in 2:
		var y := 0.42 + float(i) * 0.38
		var sag := rng.randf_range(0.01, 0.03)
		b.add_tube([Vector3(-0.95, y + 0.02, 0.1), Vector3(-0.3, y - sag, 0.11), Vector3(0.3, y - sag, 0.11), Vector3(0.95, y + 0.01, 0.1)],
			[0.055, 0.05, 0.05, 0.055], 4, wood, true, 0.0)
	b.add_tube([Vector3(-0.9, 0.12, 0.14), Vector3(0.0, 0.5, 0.15), Vector3(0.9, 0.9, 0.14)], [0.04, 0.04, 0.04], 4, wood, true)
	return b


# --- Semak: gugus bonggol rendah dengan ujung daun lebih terang ---
static func bush(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var leaf := func(nrm: Vector3, dir: Vector3) -> Color:
		var h := clampf(dir.y * 0.5 + 0.5, 0.0, 1.0)
		var j := rng.randf_range(-0.035, 0.035)
		var c := Color(0.16, 0.34, 0.17).lerp(Color(0.40, 0.62, 0.22), h)
		return Color(c.r + j, c.g + j, c.b).lightened(clampf(nrm.y, 0.0, 1.0) * 0.08)
	var blobs := [
		[Vector3(0, 0.38, 0), Vector3(0.52, 0.38, 0.5)],
		[Vector3(0.42, 0.28, 0.12), Vector3(0.36, 0.28, 0.36)],
		[Vector3(-0.38, 0.3, -0.05), Vector3(0.38, 0.3, 0.36)],
		[Vector3(0.05, 0.3, -0.38), Vector3(0.34, 0.27, 0.34)],
	]
	for i in blobs.size():
		b.add_blob(blobs[i][0], blobs[i][1], 1, 0.3, seed_value * 5 + i, leaf)
	return b


# --- Rumput liar: rumpun bilah melengkung (kartu 2 sisi) ---
static func tuft(seed_value: int) -> MeshBuilder:
	var b := MeshBuilder.new()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	for i in 11:
		var a := rng.randf() * TAU
		var r := rng.randf_range(0.0, 0.12)
		var h := rng.randf_range(0.22, 0.42)
		var bend := Vector3(cos(a), 0, sin(a)) * rng.randf_range(0.04, 0.16)
		b.add_blade(Vector3(cos(a) * r, 0, sin(a) * r), h, rng.randf_range(0.035, 0.06), bend, 3,
			Color(0.16, 0.36, 0.16), Color(0.52, 0.72, 0.28), rng.randf() * 180.0)
	return b
