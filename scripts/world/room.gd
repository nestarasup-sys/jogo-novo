extends Node2D
## Áreas compostas em cenas editáveis. Boundaries, Furniture, Visual e Spawns
## são nós reais salvos no arquivo .tscn — nada de colisão criada em _ready().

@export var room_id: String = ""
@export var room_title: String = ""
@export var room_size: Vector2 = Vector2(1280.0, 720.0)
@export var border_width: float = 34.0 # legado informativo; colisões na cena

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
        if not bool(child.get("enabled")):
            continue
        var distance: float = at.distance_to(child.global_position)
        if distance <= float(child.get("interaction_radius")) and distance < best_distance:
            winner = child.call("get_interaction")
            best_distance = distance
    return winner
