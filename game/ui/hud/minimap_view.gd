class_name MinimapView
extends Control
## Tampilan peta 2D (minimap dan peta penuh). Utara = -Z di atas. Gambar sederhana tanpa
## aset (ikon peta final menunggu ChatGPT, B-005). Warna penanda SEMENTARA.

const KIND_COLORS := {
	"portal": Color(0.75, 0.4, 0.95), "shop": Color(0.95, 0.75, 0.2), "bed": Color(0.65, 0.45, 0.8),
	"pond": Color(0.3, 0.6, 0.95), "resource": Color(0.4, 0.9, 0.4), "monster": Color(0.95, 0.25, 0.25), "animal": Color(1, 1, 1), "npc": Color(0.3, 0.8, 1.0),
}

var region_size := 60.0
var region_color := Color(0.36, 0.5, 0.30)
var player_local := Vector2.ZERO
var player_facing := Vector2(0, -1)
var markers: Array = []   # {pos: Vector2 (lokal wilayah), kind: String}


## Posisi lokal (x,z) -> koordinat tampilan.
static func to_view(local: Vector2, size: float, view_size: Vector2) -> Vector2:
	return Vector2((local.x / size + 0.5) * view_size.x, (local.y / size + 0.5) * view_size.y)


func set_data(size: float, color: Color, player: Vector2, facing: Vector2, new_markers: Array) -> void:
	region_size = size
	region_color = color
	player_local = player
	player_facing = facing
	markers = new_markers
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(region_color.r, region_color.g, region_color.b, 0.75))
	draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0.8), false, 2.0)
	var dot := maxf(size.x / 40.0, 3.0)
	for m in markers:
		var p := to_view(m["pos"], region_size, size)
		var col: Color = KIND_COLORS.get(str(m["kind"]), Color.WHITE)
		if str(m["kind"]) == "portal":
			draw_rect(Rect2(p - Vector2(dot, dot), Vector2(dot, dot) * 2.0), col)
		else:
			draw_circle(p, dot, col)
	var pp := to_view(player_local, region_size, size)
	var f := player_facing.normalized() if player_facing.length() > 0.01 else Vector2(0, -1)
	var side := Vector2(-f.y, f.x)
	draw_colored_polygon(PackedVector2Array([pp + f * dot * 2.2, pp - f * dot * 1.2 + side * dot * 1.2, pp - f * dot * 1.2 - side * dot * 1.2]), Color(1, 0.2, 0.7))
