class_name Interactable
extends Node3D
## Penanda objek yang dapat berinteraksi dengan pemain. Pasang sebagai anak
## objek dunia (pohon, pintu, petak lahan, NPC). Logika bereaksi lewat sinyal `interacted`.
## Tidak berisi visual.

signal interacted(actor: Node)

const GROUP := "interactable"

@export var interaction_type: String = "generic"
@export var enabled: bool = true
## Kunci terjemahan khusus; kosong = memakai prompt bawaan jenis interaksi.
@export var prompt_key: String = ""


func _enter_tree() -> void:
	add_to_group(GROUP)


func can_interact(_actor: Node) -> bool:
	return enabled


func interact(actor: Node) -> bool:
	if not can_interact(actor):
		return false
	interacted.emit(actor)
	Events.interaction_performed.emit(self, actor)
	return true


func resolved_prompt_key() -> String:
	if not prompt_key.is_empty():
		return prompt_key
	var row := DataRegistry.get_row("interaction_types", interaction_type)
	return str(row.get("prompt_key", "INTERACT_GENERIC"))
