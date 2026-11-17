class_name AudioBuses
extends RefCounted
## Bus audio dasar (D-032, D-045). Aset suara belum ada; ini hanya jalur volume
## yang dipakai pengaturan agar audio nanti langsung mengikuti pengaturan pemain.

const BUSES: Array[String] = ["Music", "SFX", "Ambience"]


static func ensure() -> void:
	for bus_name in BUSES:
		if AudioServer.get_bus_index(bus_name) != -1:
			continue
		AudioServer.add_bus()
		var idx := AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, bus_name)
		AudioServer.set_bus_send(idx, "Master")


## Atur volume linear 0..1 pada bus bernama. Nilai 0 = bisu.
static func set_linear(bus_name: String, value: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	AudioServer.set_bus_mute(idx, value <= 0.0)
	AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(value, 0.0001)))
