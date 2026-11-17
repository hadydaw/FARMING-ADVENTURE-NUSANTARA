class_name FarmGrid
extends RefCounted
## Kumpulan petak lahan berdasarkan ID. Meneruskan pergantian hari ke semua petak.

const SAVE_VERSION := 1

var plots: Dictionary = {}  # id -> FarmPlot
var _crop_defs: Dictionary


func _init(plot_ids: Array, crop_defs: Dictionary) -> void:
	_crop_defs = crop_defs
	for pid in plot_ids:
		plots[str(pid)] = FarmPlot.new(str(pid))


func plot(plot_id: String) -> FarmPlot:
	return plots.get(plot_id, null)


func advance_day(rained: bool) -> void:
	for p in plots.values():
		(p as FarmPlot).advance_day(rained, _crop_defs)


func reset() -> void:
	for pid in plots.keys():
		plots[pid] = FarmPlot.new(pid)


func to_dict() -> Dictionary:
	var out := {}
	for pid in plots:
		out[pid] = (plots[pid] as FarmPlot).to_dict()
	return {"v": SAVE_VERSION, "plots": out}


## Semua-atau-tidak: ID petak harus sama persis dengan yang ada.
func from_dict(data: Dictionary) -> bool:
	if int(data.get("v", -1)) != SAVE_VERSION or typeof(data.get("plots", null)) != TYPE_DICTIONARY:
		return false
	var incoming: Dictionary = data["plots"]
	if incoming.size() != plots.size():
		return false
	var staged := {}
	for pid in plots:
		if not incoming.has(pid) or typeof(incoming[pid]) != TYPE_DICTIONARY:
			return false
		var p := FarmPlot.new(pid)
		if not p.from_dict(incoming[pid], _crop_defs):
			return false
		staged[pid] = p
	plots = staged
	return true
