class_name RegionLayout
extends RefCounted
## Tata letak props wilayah yang dihasilkan secara DETERMINISTIK dari seed dan kepadatan
## (data). Posisi lokal wilayah (pusat 0,0). Menghindari titik bebas (gerbang/awal).


## counts: {prop_id: jumlah}; keep_clear: Array[Vector2]; mengembalikan baris
## {id, prop, x, z, yaw_deg, scale} seperti world_start_layout.
static func generate(seed_value: int, size: float, counts: Dictionary, keep_clear: Array, clear_radius: float) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var half := size / 2.0 - 2.0
	var out: Array = []
	var ids: Array = counts.keys()
	ids.sort()  # urutan stabil
	var n := 0
	for prop in ids:
		for i in int(counts[prop]):
			var placed := false
			for attempt in 12:
				var p := Vector2(rng.randf_range(-half, half), rng.randf_range(-half, half))
				var ok := true
				for c in keep_clear:
					if p.distance_to(c) < clear_radius:
						ok = false
						break
				if ok:
					n += 1
					out.append({"id": "g%03d" % n, "prop": str(prop), "x": snappedf(p.x, 0.01), "z": snappedf(p.y, 0.01),
						"yaw_deg": snappedf(rng.randf_range(0.0, 360.0), 0.1), "scale": snappedf(rng.randf_range(0.9, 1.2), 0.01)})
					placed = true
					break
			if not placed:
				rng.randf()  # tetap deterministik bila gagal menempatkan
	return out
