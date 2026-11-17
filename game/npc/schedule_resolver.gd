class_name ScheduleResolver
extends RefCounted
## Jadwal harian NPC (D-040): lokasi dan aktivitas ditentukan sebagai FUNGSI MURNI
## dari (jam, cuaca). Tanpa AI per-frame; hasil identik setelah muat ulang (D-040 #9).
## Konten jadwal SEMENTARA (NPC uji generik).

const SHELTER_ACTIVITY := "shelter"


## Memeriksa jadwal: menutup 0..24 tanpa celah/tumpang tindih, lokasi dikenal.
static func validate(npc: Dictionary, location_ids: Array) -> Array[String]:
	var errors: Array[String] = []
	var entries: Array = (npc.get("schedule", []) as Array).duplicate()
	entries.sort_custom(func(a, b): return int(a["from"]) < int(b["from"]))
	var cursor := 0
	for e in entries:
		if int(e["from"]) != cursor:
			errors.append("%s: celah/tumpang tindih di jam %d" % [npc.get("id", "?"), cursor])
		if int(e["to"]) <= int(e["from"]):
			errors.append("%s: rentang tidak valid %d-%d" % [npc.get("id", "?"), int(e["from"]), int(e["to"])])
		if not location_ids.has(str(e["location"])):
			errors.append("%s: lokasi tak dikenal %s" % [npc.get("id", "?"), e["location"]])
		cursor = int(e["to"])
	if cursor != 24:
		errors.append("%s: jadwal tidak berakhir di jam 24" % npc.get("id", "?"))
	if str(npc.get("rain_location", "")) != "" and not location_ids.has(str(npc["rain_location"])):
		errors.append("%s: rain_location tak dikenal" % npc.get("id", "?"))
	return errors


## {location, activity}. Saat hujan dan NPC punya rain_location: berteduh di sana.
static func resolve(npc: Dictionary, hour: int, raining: bool) -> Dictionary:
	if raining and str(npc.get("rain_location", "")) != "":
		return {"location": str(npc["rain_location"]), "activity": SHELTER_ACTIVITY}
	for e in npc.get("schedule", []):
		if hour >= int(e["from"]) and hour < int(e["to"]):
			return {"location": str(e["location"]), "activity": str(e["activity"])}
	return {"location": "", "activity": ""}
