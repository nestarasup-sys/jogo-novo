extends Node2D
## Cada .tscn de área tem Visual, Furniture, Interactions e Spawns editáveis.
## Reutilizável para qualquer novo mapa; sem nomes específicos de quarto/jardim.

@export var room_id: String = ""
@export var room_title: String = ""
@export var room_size: Vector2 = Vector2(1280.0, 720.0)
@export var border_width: float = 34.0

func _ready() -> void:
    _create_boundary()

func _create_boundary() -> void:
    var w: float = room_size.x
    var h: float = room_size.y
    var b: float = border_width
    _make_solid(Rect2(Vector2(0.0, 0.0), Vector2(w, b)))
    _make_solid(Rect2(Vector2(0.0, h - b), Vector2(w, b)))
    _make_solid(Rect2(Vector2(0.0, 0.0), Vector2(b, h)))
    _make_solid(Rect2(Vector2(w - b, 0.0), Vector2(b, h)))

func _make_solid(rect: Rect2) -> void:
    var body := StaticBody2D.new()
    body.name = "Boundary"
    body.collision_layer = 1
    body.collision_mask = 0
    var collision := CollisionShape2D.new()
    var shape := RectangleShape2D.new()
    shape.size = rect.size
    collision.shape = shape
    collision.position = rect.position + rect.size * 0.5
    body.add_child(collision)
    add_child(body)

func get_spawn(spawn_id: String) -> Vector2:
    var spawns: Node = get_node_or_null("Spawns")
    if spawns == null:
        push_error("Ambiente sem Spawns: " + room_id)
        return Vector2(-1.0, -1.0)
    var marker: Marker2D = spawns.get_node_or_null(spawn_id) as Marker2D
    if marker == null:
        push_error("Spawn inexistente: " + room_id + "/" + spawn_id)
        return Vector2(-1.0, -1.0)
    return marker.position

func nearest_interaction(at: Vector2) -> Dictionary:
    var group: Node = get_node_or_null("Interactions")
    if group == null:
        return {}
    var winner: Dictionary = {}
    var best_distance: float = INF
    for child in group.get_children():
        if not (child is Marker2D) or not child.has_method("get_interaction"):
            continue
        if not child.enabled:
            continue
        var distance: float = at.distance_to(child.global_position)
        if distance <= child.interaction_radius and distance < best_distance:
            winner = child.get_interaction()
            best_distance = distance
    return winner
