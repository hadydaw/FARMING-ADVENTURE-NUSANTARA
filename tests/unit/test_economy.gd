extends TestCase

func _eco() -> Economy:
	return Economy.new(DataRegistry.get_row("economy_config", "default"), DataRegistry.rows("item_prices"))


func _inv() -> Inventory:
	var stack := {}
	for it in DataRegistry.rows("items"):
		stack[str(it["id"])] = int(it["stack_max"])
	return Inventory.new(24, func(id): return stack.get(id, 0))


func run() -> void:
	var items := {}
	for it in DataRegistry.rows("items"):
		items[str(it["id"])] = true
	for p in DataRegistry.rows("item_prices"):
		check(bool(p.get("provisional", false)) and items.has(str(p["item"])), "harga sementara dan item ada: %s" % p["item"])
		check(int(p["buy"]) >= 0 and int(p["sell"]) >= 0, "harga tidak negatif")
		check(int(p["buy"]) == 0 or int(p["sell"]) <= int(p["buy"]), "jual tidak melebihi beli (tidak ada uang gratis): %s" % p["item"])
	for sh in DataRegistry.rows("shops"):
		for item in sh["stock"]:
			check(_eco().buy_price(str(item)) > 0, "barang toko punya harga beli: %s" % item)
	check(tr("SHOP_TEST") != "SHOP_TEST" and tr("CURRENCY_TEST") != "CURRENCY_TEST", "terjemahan toko dan mata uang")

	var e := _eco()
	var inv := _inv()
	check_eq(e.money, 100, "uang awal dari data")
	var stock: Array = DataRegistry.get_row("shops", "shop_test")["stock"]
	# Beli
	var r := e.buy(inv, "seed_test_a", 3, stock)
	check(bool(r["ok"]) and int(r["total"]) == 30, "beli 3 benih = 30")
	check_eq(e.money, 70, "uang berkurang")
	check_eq(inv.count("seed_test_a"), 3, "benih masuk tas")
	check_eq(str(e.buy(inv, "produce_test_a", 1, stock)["reason"]), "not_for_sale", "bukan stok toko")
	check_eq(str(e.buy(inv, "seed_test_a", 100, stock)["reason"]), "no_money", "uang kurang")
	check_eq(e.money, 70, "gagal beli tidak mengubah uang")
	check_eq(str(e.buy(inv, "seed_test_a", 0, stock)["reason"]), "not_for_sale", "jumlah 0 ditolak")
	# Tas penuh
	var full := _inv()
	for i in 24:
		full.add("tool_hoe", 1)
	var e2 := _eco()
	check_eq(str(e2.buy(full, "seed_test_a", 1, stock)["reason"]), "inventory_full", "tas penuh menolak beli")
	check_eq(e2.money, 100, "uang utuh saat tas penuh")
	# Jual dan harga dinamis
	inv.add("produce_test_a", 5)
	check_eq(e.sell_price("produce_test_a", "season_1"), 20, "harga dasar")
	check_eq(e.sell_price("produce_test_a", "season_2"), 22, "pengali musim 1.1")
	check_eq(e.sell_price("produce_test_a", "season_3"), 18, "pengali musim 0.9")
	check_eq(e.sell_price("tool_hoe", "season_1"), 0, "alat tidak dijual")
	var q := e.quote_sell("produce_test_a", 3, "season_1")
	var sold := e.sell(inv, "produce_test_a", 3, "season_1")
	check(bool(sold["ok"]) and int(sold["total"]) == q, "jual sesuai kuotasi")
	check(q < 3 * 20, "permintaan menurun: total < 3 x harga dasar (%d)" % q)
	check_eq(e.money, 70 + q, "uang bertambah")
	check_eq(inv.count("produce_test_a"), 2, "item berkurang")
	check(e.sell_price("produce_test_a", "season_1") < 20, "harga turun setelah menjual")
	check_eq(str(e.sell(inv, "produce_test_a", 99, "season_1")["reason"]), "no_item", "jual lebih dari punya ditolak")
	check_eq(inv.count("produce_test_a"), 2, "gagal jual tidak mengubah tas")
	check_eq(str(e.sell(inv, "tool_hoe", 1, "season_1")["reason"]), "not_buying", "toko tidak membeli alat")
	e.advance_day()
	check_eq(e.sell_price("produce_test_a", "season_1"), 20, "harga pulih tiap hari")
	# Batas lantai harga
	var low := _eco()
	check(low.sell_price("produce_test_b", "season_1", 100) >= 1, "harga minimal 1")
	check(low.sell_price("produce_test_b", "season_1", 100) == int(floor(35.0 * 0.3)), "lantai permintaan 30%")
	# Tidak ada arbitrase beli-jual
	var arb := _eco()
	var ai := _inv()
	var start := arb.money
	arb.buy(ai, "seed_test_a", 10, stock)
	arb.sell(ai, "seed_test_a", 10, "season_2")
	check(arb.money <= start, "beli lalu jual langsung tidak untung")
	# Save/load
	var d := e.to_dict()
	var e3 := _eco()
	check(e3.from_dict(d) and e3.money == e.money, "muat ekonomi")
	var bad := d.duplicate(true)
	bad["money"] = -5
	check(not e3.from_dict(bad), "uang negatif ditolak")
	var bad2 := d.duplicate(true)
	bad2["sold_today"] = {"tak_ada": 1}
	check(not e3.from_dict(bad2), "item tak dikenal ditolak")
	check_eq(e3.money, e.money, "status utuh setelah gagal")

	# Sesi: ekonomi ikut simpan/muat dan reset tiap hari
	var clock := GameClock.new(DataRegistry.get_row("time_config", "default"))
	var ids: Array = []
	for rr in DataRegistry.rows("farm_plots"):
		ids.append(str(rr["id"]))
	var ex := {"economy_config": DataRegistry.get_row("economy_config", "default"), "item_prices": DataRegistry.rows("item_prices"), "shops": DataRegistry.rows("shops"),
		"fish_species": DataRegistry.rows("fish_species"), "fishing_config": DataRegistry.get_row("fishing_config", "default"),
		"animals": DataRegistry.rows("animals"), "livestock_config": DataRegistry.get_row("livestock_config", "default")}
	var s := FarmingSession.new(clock, DataRegistry.rows("items"), DataRegistry.rows("crops"), ids, DataRegistry.get_row("farm_config", "default"),
		DataRegistry.rows("weather_types"), DataRegistry.rows("weather_chances"), 3, DataRegistry.rows("vitality_meters"), DataRegistry.get_row("rest_config", "default"), ex)
	check(bool(s.shop_buy("shop_test", "feed_test", 2)["ok"]), "beli lewat sesi")
	check_eq(s.economy.money, 90, "uang sesi")
	check(not bool(s.shop_buy("toko_tak_ada", "feed_test", 1)["ok"]), "toko tak dikenal ditolak")
	check(bool(s.shop_sell("produce_test_b", 1)["ok"]) == false, "jual item yang tidak dimiliki ditolak")
	var saved := s.to_dict()
	var s2 := FarmingSession.new(GameClock.new(DataRegistry.get_row("time_config", "default")), DataRegistry.rows("items"), DataRegistry.rows("crops"), ids,
		DataRegistry.get_row("farm_config", "default"), DataRegistry.rows("weather_types"), DataRegistry.rows("weather_chances"), 0, DataRegistry.rows("vitality_meters"), DataRegistry.get_row("rest_config", "default"), ex)
	check(s2.from_dict(saved) and s2.economy.money == 90, "muat sesi dengan ekonomi")
