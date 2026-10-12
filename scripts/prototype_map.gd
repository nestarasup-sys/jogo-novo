extends Node2D
## Três cenas reutilizam este construtor visual, sem tiles nem assets pagos.

@export_enum("bedroom", "corridor", "garden") var map_id: String = "bedroom"

const SIZE := Vector2(1280, 720)
const WALL := 34.0
var props: Array[Dictionary] = []
var interactions: Array[Dictionary] = []
var floor_color: Color = Color("#eadcc9")
var border_color: Color = Color("#b7a18d")

func _ready() -> void:
    _create_boundary()
    match map_id:
        "bedroom": _create_bedroom()
        "corridor": _create_corridor()
        "garden": _create_garden()
        _: push_error("Unknown map_id: " + map_id)
    queue_redraw()

func _add_wall(rect: Rect2) -> void:
    var body := StaticBody2D.new()
    body.collision_layer = 1
    body.collision_mask = 0
    var shape := RectangleShape2D.new()
    shape.size = rect.size
    var collider := CollisionShape2D.new()
    collider.shape = shape
    collider.position = rect.position + rect.size * 0.5
    body.add_child(collider)
    add_child(body)

func _add_prop(rect: Rect2, color: Color, label: String, solid: bool = true) -> void:
    props.append({"rect": rect, "color": color, "label": label})
    if solid:
        _add_wall(rect)

func _add_interaction(pos: Vector2, label: String, kind: String, target: String = "", spawn: Vector2 = Vector2.ZERO, text: String = "") -> void:
    interactions.append({"pos": pos, "label": label, "kind": kind, "target": target, "spawn": spawn, "text": text})

func _create_boundary() -> void:
    _add_wall(Rect2(0, 0, SIZE.x, WALL))
    _add_wall(Rect2(0, SIZE.y - WALL, SIZE.x, WALL))
    _add_wall(Rect2(0, 0, WALL, SIZE.y))
    _add_wall(Rect2(SIZE.x - WALL, 0, WALL, SIZE.y))

func _create_bedroom() -> void:
    floor_color = Color("#f3e5d6")
    border_color = Color("#bf98a0")
    _add_prop(Rect2(170, 195, 225, 165), Color("#a879a2"), "CAMA")
    _add_prop(Rect2(815, 188, 225, 122), Color("#a47e5f"), "ESCRIVANINHA")
    _add_prop(Rect2(105, 480, 162, 128), Color("#9b796c"), "ARMARIO")
    _add_prop(Rect2(1030, 460, 125, 150), Color("#b18b71"), "POLTRONA")
    _add_interaction(Vector2(445, 281), "Examinar cama", "message", "", Vector2.ZERO, "Uma cama confortável. O descanso será implementado em outra etapa.")
    _add_interaction(Vector2(764, 269), "Examinar escrivaninha", "message", "", Vector2.ZERO, "Uma escrivaninha provisória. Cartas e inventário virão depois.")
    _add_interaction(Vector2(640, 624), "Sair para o corredor", "door", "corridor", Vector2(640, 166))

func _create_corridor() -> void:
    floor_color = Color("#e4d7c9")
    border_color = Color("#ad9585")
    _add_prop(Rect2(95, 86, 195, 64), Color("#9c7b67"), "QUADRO")
    _add_prop(Rect2(990, 86, 195, 64), Color("#9c7b67"), "QUADRO")
    _add_prop(Rect2(108, 345, 178, 86), Color("#88765a"), "BANCO")
    _add_prop(Rect2(994, 345, 178, 86), Color("#88765a"), "BANCO")
    _add_interaction(Vector2(641, 112), "Entrar no quarto", "door", "bedroom", Vector2(640, 558))
    _add_interaction(Vector2(640, 620), "Sair para o jardim", "door", "garden", Vector2(640, 158))
    _add_interaction(Vector2(362, 116), "Observar quadro", "message", "", Vector2.ZERO, "Um quadro decorativo. A história do palácio ainda não foi definida.")

func _create_garden() -> void:
    floor_color = Color("#a4c49c")
    border_color = Color("#6e9c79")
    _add_prop(Rect2(550, 296, 180, 134), Color("#8cbdc4"), "FONTE")
    for x in [135.0, 310.0, 955.0, 1130.0]:
        for y in [180.0, 535.0]:
            _add_prop(Rect2(x - 35, y - 36, 70, 72), Color("#518c64"), "", true)
    _add_interaction(Vector2(640, 112), "Voltar ao corredor", "door", "corridor", Vector2(640, 545))
    _add_interaction(Vector2(640, 475), "Examinar fonte", "message", "", Vector2.ZERO, "O som da água traz tranquilidade. Esta interação testa objetos do cenário.")

func nearest_interaction(from_pos: Vector2, max_distance: float = 94.0) -> Dictionary:
    var selected: Dictionary = {}
    var best := max_distance
    for item in interactions:
        var distance := from_pos.distance_to(item["pos"])
        if distance < best:
            selected = item
            best = distance
    return selected

func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, SIZE), floor_color)
    if map_id == "garden":
        draw_rect(Rect2(520, 34, 240, 652), Color(Color("#e5d9b6"), 0.8))
        draw_rect(Rect2(34, 345, 1212, 45), Color(Color("#e5d9b6"), 0.45))
    elif map_id == "corridor":
        draw_rect(Rect2(515, 36, 250, 648), Color(Color("#a75e67"), 0.62))
        draw_rect(Rect2(538, 36, 204, 648), Color(Color("#d8b07e"), 0.35))
    else:
        for x in range(60, 1240, 90):
            draw_line(Vector2(x, 35), Vector2(x, 685), Color(Color("#b49a86"), 0.22), 2.0)
    for p in props:
        var rect: Rect2 = p["rect"]
        draw_rect(rect, p["color"])
        draw_rect(rect, Color("#69555a"), false, 4.0)
        if not p["label"].is_empty():
            draw_string(ThemeDB.fallback_font, rect.position + Vector2(8, minf(36.0, rect.size.y * 0.58)), p["label"], HORIZONTAL_ALIGNMENT_LEFT, int(rect.size.x - 12), 15, Color.WHITE)
    draw_rect(Rect2(0, 0, SIZE.x, WALL), border_color)
    draw_rect(Rect2(0, SIZE.y - WALL, SIZE.x, WALL), border_color)
    draw_rect(Rect2(0, 0, WALL, SIZE.y), border_color)
    draw_rect(Rect2(SIZE.x - WALL, 0, WALL, SIZE.y), border_color)
    for item in interactions:
        if item["kind"] == "door":
            var is_bottom: bool = item["pos"].y > SIZE.y * 0.5
            var door_rect := Rect2(item["pos"] + Vector2(-55, 34 if is_bottom else -69), Vector2(110, 36))
            draw_rect(door_rect, Color("#8e654f"))
            draw_rect(door_rect, Color("#ffdeb0"), false, 3.0)
            draw_circle(item["pos"], 8, Color("#ffdf9b"))
        else:
            draw_arc(item["pos"], 17, 0, TAU, 24, Color("#ffe5a1"), 3.0)
