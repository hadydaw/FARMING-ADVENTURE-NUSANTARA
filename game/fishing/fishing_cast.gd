class_name FishingCast
extends RefCounted
## Satu lemparan pancing: menunggu -> gigitan -> (ditarik tepat waktu = dapat) / lepas.
## Waktu dihitung dari delta nyata (detik) yang diberikan pemanggil.

signal state_changed(state: String)

const WAITING := "waiting"
const BITE := "bite"
const CAUGHT := "caught"
const ESCAPED := "escaped"

var species_id: String
var state := WAITING
var failure := ""
var _wait: float
var _window: float
var _t := 0.0


func _init(plan: Dictionary) -> void:
	species_id = str(plan["species_id"])
	_wait = float(plan["wait"])
	_window = float(plan["window"])


func is_finished() -> bool:
	return state == CAUGHT or state == ESCAPED


func advance(delta: float) -> void:
	if is_finished() or delta <= 0.0:
		return
	_t += delta
	if state == WAITING and _t >= _wait:
		_to_state(BITE)
	if state == BITE and _t >= _wait + _window:
		failure = "late"
		_to_state(ESCAPED)


## Menarik pancing. Terlalu cepat (saat menunggu) = ikan lepas; saat gigitan = dapat.
func reel() -> String:
	if is_finished():
		return state
	if state == BITE:
		_to_state(CAUGHT)
	else:
		failure = "early"
		_to_state(ESCAPED)
	return state


func _to_state(s: String) -> void:
	state = s
	state_changed.emit(s)
