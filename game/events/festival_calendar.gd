class_name FestivalCalendar
extends RefCounted
## Kalender festival dasar (D-029, SEMENTARA): festival jatuh pada musim+hari-dalam-musim tertentu.
## Hadiah diklaim sekali per festival per tahun (kunci "id:tahun"); tas penuh = hadiah terlewat
## (tetap tercatat agar tidak dicoba ulang). Hari/musim dari GameClock, bukan jam perangkat.

const SAVE_VERSION := 1

var _rows: Array = []
var _known: Dictionary = {}
var _claimed: Dictionary = {}


func _init(rows: Array) -> void:
	_rows = rows
	for r in rows:
		_known[str(r["id"])] = r


## Festival pada musim dan hari-dalam-musim (1-based); {} bila tidak ada.
func event_on(season_id: String, day_of_season: int) -> Dictionary:
	for r in _rows:
		if str(r["season"]) == season_id and int(r["day"]) == day_of_season:
			return r
	return {}


## Festival berikutnya (termasuk hari ini bila belum diklaim): {row, days_ahead} atau {}.
func next_event(clock: GameClock) -> Dictionary:
	var best: Dictionary = {}
	var today := clock.day_index()
	for offset in clock.days_per_year():
		var day := today + offset
		var season := clock.season_id_for_day(day)
		var dos := day % int(clock._config["days_per_season"]) + 1
		var ev := event_on(season, dos)
		if not ev.is_empty() and not (offset == 0 and _claimed.has("%s:%d" % [ev["id"], clock.year()])):
			best = {"row": ev, "days_ahead": offset}
			break
	return best


## Klaim festival hari ini. {ok, event, gift_given}. ok=false bila tak ada festival / sudah diklaim.
func claim_today(clock: GameClock, inventory: Inventory, combat: CombatState) -> Dictionary:
	var ev := event_on(clock.season_id(), clock.day_of_season())
	if ev.is_empty():
		return {"ok": false, "event": {}, "gift_given": false}
	var key := "%s:%d" % [ev["id"], clock.year()]
	if _claimed.has(key):
		return {"ok": false, "event": ev, "gift_given": false}
	_claimed[key] = true
	var g: Dictionary = ev["gift"]
	var given := inventory.can_add(str(g["item"]), int(g["count"]))
	if given:
		inventory.add(str(g["item"]), int(g["count"]))
		combat.exp_total += int(ev.get("exp", 0))
	return {"ok": true, "event": ev, "gift_given": given}


func reset() -> void:
	_claimed.clear()


func to_dict() -> Dictionary:
	return {"v": SAVE_VERSION, "claimed": _claimed.keys()}


func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("claimed", null)) != TYPE_ARRAY:
		return false
	var c: Dictionary = {}
	for k in data["claimed"]:
		var parts := str(k).split(":")
		if parts.size() != 2 or not _known.has(parts[0]) or not parts[1].is_valid_int():
			return false
		c[str(k)] = true
	_claimed = c
	return true
