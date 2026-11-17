class_name FishingModel
extends RefCounted
## Memancing (D-025), logika murni dan DETERMINISTIK: hasil tiap lemparan ditentukan oleh
## (world_seed, hari, nomor lemparan hari itu) sehingga muat-ulang tidak mengulang undian
## (D-055). Spesies, peluang, waktu, dan efek umpan SEMENTARA (data uji).


## Spesies yang bisa muncul untuk habitat/musim/cuaca/jam ini.
static func available(species: Array, habitat: String, season_id: String, weather_id: String, hour: int) -> Array:
	var out: Array = []
	for s in species:
		if not (s["habitats"] as Array).has(habitat):
			continue
		if not (s["seasons"] as Array).has(season_id):
			continue
		if not (s["weather"] as Array).has(weather_id):
			continue
		if hour < int(s["hour_from"]) or hour >= int(s["hour_to"]):
			continue
		out.append(s)
	return out


## Rencana satu lemparan: {species_id, wait, window}. Kosong bila tidak ada kandidat.
static func plan_cast(world_seed: int, day: int, cast_no: int, candidates: Array, with_bait: bool, cfg: Dictionary) -> Dictionary:
	if candidates.is_empty():
		return {}
	var ordered: Array = candidates.duplicate()
	ordered.sort_custom(func(a, b): return str(a["id"]) < str(b["id"]))
	var total := 0
	var weights: Array[int] = []
	for s in ordered:
		var w := int(s["weight"])
		if with_bait and int(s["rarity"]) > 1:
			w *= int(cfg["bait_rarity_multiplier"])
		weights.append(w)
		total += w
	var rng := RandomNumberGenerator.new()
	rng.seed = GameClock.daily_seed(world_seed + cast_no * 7919, day)
	var roll := rng.randi() % maxi(total, 1)
	var acc := 0
	var chosen := str(ordered[-1]["id"])
	for i in ordered.size():
		acc += weights[i]
		if roll < acc:
			chosen = str(ordered[i]["id"])
			break
	var wait := lerpf(float(cfg["wait_min"]), float(cfg["wait_max"]), rng.randf())
	return {"species_id": chosen, "wait": wait, "window": float(cfg["bite_window"])}
