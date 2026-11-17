class_name RegionRules
extends RefCounted
## Aturan pembukaan wilayah (D-054/D-028: wilayah tidak dibuka semua sejak awal; pembukaan
## mengikuti progres). Jenis syarat dan isinya SEMENTARA: "always", "min_day", "has_item".


static func is_unlocked(region: Dictionary, day_index: int, inventory: Inventory) -> bool:
	var rule: Dictionary = region.get("unlock", {"type": "always"})
	match str(rule.get("type", "always")):
		"always":
			return true
		"min_day":
			return day_index >= int(rule.get("day", 0))
		"has_item":
			return inventory != null and inventory.has(str(rule.get("item", "")))
	return false  # jenis tak dikenal: tetap terkunci (aman)


## Wilayah yang memuat posisi dunia (x,z); "" bila di luar semua wilayah.
static func region_at(regions: Array, world_pos: Vector3) -> String:
	for r in regions:
		var half := float(r["size"]) / 2.0
		if absf(world_pos.x - float(r["origin_x"])) <= half and absf(world_pos.z) <= half:
			return str(r["id"])
	return ""
