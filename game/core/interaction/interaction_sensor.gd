class_name InteractionSensor
extends Node3D
## Memilih objek interaksi terbaik di sekitar aktor (jarak + arah hadap) dan
## memicunya saat tombol "interact" ditekan. Pemilihan memakai fungsi statis murni
## sehingga dapat diuji tanpa fisika.

var actor: Node3D
var facing: Vector3 = Vector3(0, 0, -1)
var current: Interactable = null


## Skor kandidat; -1 bila tidak valid. Skor lebih tinggi = lebih baik.
static func score(origin: Vector3, forward: Vector3, target: Vector3, max_distance: float, min_facing_dot: float) -> float:
	var flat := Vector3(target.x - origin.x, 0.0, target.z - origin.z)
	var dist := flat.length()
	if dist > max_distance:
		return -1.0
	if dist < 0.0001:
		return 2.0  # tepat di atas objek: selalu valid
	var f := Vector3(forward.x, 0.0, forward.z)
	if f.length_squared() < 0.000001:
		return 1.0 - dist / maxf(max_distance, 0.0001)
	var dot := f.normalized().dot(flat / dist)
	if dot < min_facing_dot:
		return -1.0
	return dot * 0.5 + (1.0 - dist / maxf(max_distance, 0.0001))


## Memilih Interactable terbaik dari daftar. Null bila tidak ada yang valid.
static func pick_best(origin: Vector3, forward: Vector3, candidates: Array, actor_node: Node = null) -> Interactable:
	var best: Interactable = null
	var best_score := -1.0
	for c in candidates:
		var it := c as Interactable
		if it == null or not is_instance_valid(it) or not it.is_inside_tree():
			continue
		if not it.can_interact(actor_node):
			continue
		var row := DataRegistry.get_row("interaction_types", it.interaction_type)
		var s := score(origin, forward, it.global_position,
			float(row.get("max_distance", 2.0)), float(row.get("min_facing_dot", 0.2)))
		if s > best_score:
			best_score = s
			best = it
	return best


func refresh() -> Interactable:
	var origin := (actor.global_position if actor != null else global_position)
	var best := pick_best(origin, facing, get_tree().get_nodes_in_group(Interactable.GROUP), actor)
	if best != current:
		current = best
		Events.interaction_target_changed.emit(current)
	return current


func try_interact() -> bool:
	refresh()
	if current == null:
		return false
	return current.interact(actor)


func _process(_delta: float) -> void:
	refresh()
	if Input.is_action_just_pressed("interact"):
		try_interact()
