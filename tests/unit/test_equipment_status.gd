extends TestCase

func _session() -> FarmingSession:
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	return FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), [], DataRegistry.get_row("farm_config", "default"), [], [], 1, DataRegistry.rows("vitality_meters"), {}, {
		"monsters": DataRegistry.rows("monsters"), "monster_spawns": DataRegistry.rows("monster_spawns"), "combat_config": DataRegistry.get_row("combat_config", "default"),
		"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"),
		"statuses": DataRegistry.rows("statuses")})


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = it
	for st in DataRegistry.rows("statuses"):
		check(bool(st.get("provisional", false)) and int(st["duration"]) > 0, "status valid: %s" % st["id"])
		check(tr(str(st["name_key"])) != str(st["name_key"]), "terjemahan status")
	for m in DataRegistry.rows("monsters"):
		if m.has("inflict"):
			check(DataRegistry.has_row("statuses", str(m["inflict"]["effect"])), "efek monster ada: %s" % m["id"])
	for k in ["potion_test_antidote", "potion_test_regen"]:
		check(items.has(k), "item ada: %s" % k)

	# --- Perlengkapan ---
	var s := _session()
	var base := s.combat.player_attack()
	check_eq(str(s.equip_item("weapon_test_sword")["reason"]), "no_item", "belum punya")
	check_eq(str(s.equip_item("herb_test")["reason"]), "not_equippable", "bukan perlengkapan")
	s.inventory.add("weapon_test_sword", 1)
	check(bool(s.equip_item("weapon_test_sword")["ok"]), "pasang pedang")
	check_eq(s.inventory.count("weapon_test_sword"), 0, "keluar dari tas")
	check_eq(s.combat.player_attack(), base + 4, "serangan naik")
	s.inventory.add("armor_test_vest", 1)
	check(bool(s.equip_item("armor_test_vest")["ok"]), "pasang rompi")
	check_eq(s.combat.player_defense(), 1, "pertahanan naik")
	check_eq(int(s.attack_monster("ms_forest_1")["taken"]), 2, "rompi mengurangi serangan balik (3-1)")
	check(bool(s.unequip_slot("weapon")["ok"]), "lepas pedang")
	check_eq(s.inventory.count("weapon_test_sword"), 1, "kembali ke tas")
	check_eq(s.combat.player_attack(), base, "serangan turun")
	check_eq(str(s.unequip_slot("weapon")["reason"]), "empty", "slot kosong")
	# Pasang menggantikan: item lama kembali
	s.inventory.add("weapon_test_sword", 1)
	s.equip_item("weapon_test_sword")
	var s_extra := s.inventory.count("weapon_test_sword")
	check_eq(s_extra, 1, "satu pedang lagi di tas")
	check(bool(s.equip_item("weapon_test_sword")["ok"]), "ganti pedang")
	check_eq(s.inventory.count("weapon_test_sword"), 1, "pedang lama kembali, jumlah total sama")

	# --- Status: racun berkala, tidak mematikan ---
	var p := _session()
	check(p.inflict("poison"), "racun terkena")
	check(not p.inflict("palsu"), "status tak dikenal ditolak")
	var hp := p.vitality.value("health")
	p._clock.add_minutes(30)
	p.tick_status()
	check_eq(p.vitality.value("health"), hp - 6, "3 tik x 2 HP")
	p._clock.add_minutes(60)
	p.tick_status()
	check(not p.status.is_active("poison"), "racun habis (durasi 60)")
	check_eq(p.vitality.value("health"), hp - 12, "total 6 tik (durasi), tidak lebih")
	# Tidak mematikan
	var q := _session()
	q.vitality.change("health", -(q.vitality.value("health") - 3))
	q.inflict("poison")
	q._clock.add_minutes(60)
	q.tick_status()
	check_eq(q.vitality.value("health"), 1, "racun tidak membunuh (HP min 1)")
	# Pemulihan
	var r := _session()
	r.vitality.change("health", -50)
	r.inflict("regen")
	r._clock.add_minutes(20)
	r.tick_status()
	check_eq(r.vitality.value("health"), 100 - 50 + 2, "regen 2 tik")
	# Lemah menurunkan serangan lalu pulih
	var w := _session()
	var a0 := w.combat.player_attack()
	w.inflict("weaken")
	check_eq(w.combat.player_attack(), a0 - 2, "lemah -2 serangan")
	w._clock.add_minutes(130)
	w.tick_status()
	check_eq(w.combat.player_attack(), a0, "serangan pulih setelah habis")
	# Segarkan, bukan menumpuk
	var f := _session()
	f.inflict("weaken")
	f._clock.add_minutes(60)
	f.inflict("weaken")
	f._clock.add_minutes(100)   # 160 > 120 dari awal, tapi 100 < 120 dari penyegaran
	f.tick_status()
	check(f.status.is_active("weaken"), "penyegaran memperpanjang")
	check_eq(f.combat.player_attack(), a0 - 2, "tidak menumpuk")
	# Item: penawar & pemulih
	var it := _session()
	it.inventory.add("potion_test_antidote", 2)
	check_eq(str(it.use_item("potion_test_antidote")["reason"]), "no_effect", "penawar tanpa racun ditolak")
	check_eq(it.inventory.count("potion_test_antidote"), 2, "item tidak terpakai")
	it.inflict("poison")
	check(bool(it.use_item("potion_test_antidote")["ok"]), "penawar menyembuhkan")
	check(not it.status.is_active("poison"), "racun hilang")
	it.inventory.add("potion_test_regen", 1)
	check(bool(it.use_item("potion_test_regen")["ok"]) and it.status.is_active("regen"), "ramuan pemulih memberi regen")
	# Pingsan menghapus status
	var fa := _session()
	fa.inflict("poison")
	fa.economy.money = 100
	fa.vitality.change("health", -(fa.vitality.value("health") - 2))
	fa.monster_retaliate("ms_forest_3")
	check(not fa.status.is_active("poison"), "pingsan menghapus status")
	# Monster menimbulkan racun (roll rendah): babi atk 6
	var m := _session()
	var got_poison := false
	for i in 40:
		m.vitality.change("health", 100)
		m.monster_retaliate("ms_forest_3")
		if m.status.is_active("poison"):
			got_poison = true
			break
	check(got_poison, "babi hutan akhirnya meracuni")

	# --- Simpan/muat + rollback ---
	var sv := _session()
	sv.inventory.add("weapon_test_sword", 1)
	sv.equip_item("weapon_test_sword")
	sv.inflict("weaken")
	var saved := sv.to_dict()
	var ld := _session()
	check(ld.from_dict(saved), "muat")
	check_eq(ld.equipment.slot_item("weapon"), "weapon_test_sword", "perlengkapan dipulihkan")
	check(ld.status.is_active("weaken"), "status dipulihkan")
	check_eq(ld.combat.player_attack(), sv.combat.player_attack(), "serangan sama setelah muat")
	var bad := saved.duplicate(true)
	bad["equipment"]["equipped"] = {"weapon": "herb_test"}
	var bs := _session()
	bs.inventory.add("armor_test_vest", 1)
	bs.equip_item("armor_test_vest")
	var before := JSON.stringify(bs.to_dict())
	check(not bs.from_dict(bad), "perlengkapan tak sah ditolak")
	check_eq(JSON.stringify(bs.to_dict()), before, "rollback utuh")
	var bad2 := saved.duplicate(true)
	bad2["status"]["active"] = {"palsu": {"end": 5, "last": 0}}
	check(not bs.from_dict(bad2), "status tak dikenal ditolak")
	check_eq(JSON.stringify(bs.to_dict()), before, "rollback utuh (2)")
	var old := saved.duplicate(true)
	old.erase("equipment")
	old.erase("status")
	check(bs.from_dict(old), "save lama termuat")
	check_eq(bs.equipment.slot_item("armor"), "", "perlengkapan direset")
	check(bs.status.active_ids().is_empty(), "status direset")
