class_name WeatherModel
extends RefCounted
## Cuaca harian deterministik: fungsi murni dari (world_seed, hari, musim) lewat
## GameClock.daily_seed. Tidak memakai jam perangkat; memuat save pada hari yang sama
## selalu memberi cuaca yang sama (D-055: tidak dapat diulang lewat muat-ulang).
## Daftar cuaca dan peluang SEMENTARA (data uji; D-030 belum menetapkan detail).

## weights: {weather_id: bobot >= 0}. Mengembalikan id cuaca, atau "" bila tidak ada bobot.
static func pick(world_seed: int, day: int, weights: Dictionary) -> String:
	var ids: Array = weights.keys()
	ids.sort()  # urutan stabil lintas platform
	var total := 0
	for id in ids:
		total += maxi(int(weights[id]), 0)
	if total <= 0:
		return ""
	var rng := RandomNumberGenerator.new()
	rng.seed = GameClock.daily_seed(world_seed, day)
	var roll := rng.randi() % total
	var acc := 0
	for id in ids:
		acc += maxi(int(weights[id]), 0)
		if roll < acc:
			return str(id)
	return str(ids[-1])


static func weather_for(world_seed: int, day: int, season_id: String, chances: Dictionary) -> String:
	if not chances.has(season_id):
		return ""
	return pick(world_seed, day, chances[season_id]["weights"])
