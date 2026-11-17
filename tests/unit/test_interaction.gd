extends TestCase

func run() -> void:
	# Skor murni
	var fwd := Vector3(0, 0, -1)
	check(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, -1), 2.0, 0.2) > 0.0, "objek di depan valid")
	check_eq(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, -3), 2.0, 0.2), -1.0, "terlalu jauh ditolak")
	check_eq(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, 1), 2.0, 0.2), -1.0, "di belakang ditolak")
	check(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, -0.5), 2.0, 0.2) > InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, -1.5), 2.0, 0.2), "lebih dekat lebih tinggi")
	check(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 0, -1), 2.0, 0.2) > InteractionSensor.score(Vector3.ZERO, fwd, Vector3(1, 0, -1), 2.0, 0.2), "lurus di depan lebih tinggi dari serong")
	check(InteractionSensor.score(Vector3.ZERO, fwd, Vector3(0, 5, -1), 2.0, 0.2) > 0.0, "tinggi diabaikan (bidang tanah)")

	var holder := Node3D.new()
	tree.root.add_child(holder)
	var actor := Node3D.new()
	holder.add_child(actor)
	var sensor := InteractionSensor.new()
	sensor.actor = actor
	holder.add_child(sensor)
	var near_obj := _make(holder, "Dekat", Vector3(0, 0, -0.8))
	var far_obj := _make(holder, "Jauh", Vector3(0, 0, -1.8))
	var side_obj := _make(holder, "Samping", Vector3(-1.5, 0, 0))
	var behind := _make(holder, "Belakang", Vector3(0, 0, 1.0))
	sensor.facing = fwd

	var changes: Array[Node] = []
	var cb := func(t): changes.append(t)
	tree.root.get_node("Events").interaction_target_changed.connect(cb)

	var best := sensor.refresh()
	check_eq(best, near_obj, "memilih objek terdekat di depan")
	check_eq(changes.size(), 1, "sinyal target berubah terkirim")
	sensor.refresh()
	check_eq(changes.size(), 1, "tidak ada sinyal ganda tanpa perubahan")

	# Interaksi
	var fired: Array[Node] = []
	near_obj.interacted.connect(func(a): fired.append(a))
	var performed: Array[Node] = []
	var cb2 := func(t, _a): performed.append(t)
	tree.root.get_node("Events").interaction_performed.connect(cb2)
	check(sensor.try_interact(), "interaksi berhasil")
	check_eq(fired, [actor], "sinyal interacted membawa aktor")
	check_eq(performed, [near_obj], "event bus menerima interaksi")

	# Dinonaktifkan -> pindah ke kandidat berikutnya
	near_obj.enabled = false
	check_eq(sensor.refresh(), far_obj, "objek nonaktif dilewati")
	check(not near_obj.interact(actor), "objek nonaktif tak bisa berinteraksi")

	# Menghadap ke samping memilih objek samping; tanpa kandidat = null
	sensor.facing = Vector3(-1, 0, 0)
	check_eq(sensor.refresh(), side_obj, "arah hadap mengubah pilihan")
	far_obj.enabled = false
	side_obj.enabled = false
	behind.enabled = false
	check_eq(sensor.refresh(), null, "tanpa kandidat valid = null")
	check(not sensor.try_interact(), "tanpa target interaksi gagal")

	# Prompt dari data
	check_eq(near_obj.resolved_prompt_key(), "INTERACT_GENERIC", "prompt bawaan dari tabel jenis")
	near_obj.prompt_key = "KUNCI_KHUSUS"
	check_eq(near_obj.resolved_prompt_key(), "KUNCI_KHUSUS", "prompt khusus menimpa bawaan")

	tree.root.get_node("Events").interaction_target_changed.disconnect(cb)
	tree.root.get_node("Events").interaction_performed.disconnect(cb2)
	holder.free()


func _make(parent: Node, n: String, pos: Vector3) -> Interactable:
	var it := Interactable.new()
	it.name = n
	parent.add_child(it)
	it.global_position = pos
	return it
