extends Marker2D
## Uma interação pode ser inspeção ou porta. Sem scripts específicos por objeto.

@export_enum("inspect", "door") var interaction_type: String = "inspect"
@export var action_label: String = "Interagir"
@export_multiline var message: String = ""
@export var destination_room: String = ""
@export var destination_spawn: String = ""
@export_range(24.0, 240.0, 1.0) var interaction_radius: float = 94.0
@export var enabled: bool = true

func get_interaction() -> Dictionary:
    return {
        "kind": interaction_type,
        "label": action_label,
        "message": message,
        "target": destination_room,
        "spawn_id": destination_spawn,
        "source_position": global_position
    }

func _draw() -> void:
    if not Engine.is_editor_hint():
        return
    draw_circle(Vector2.ZERO, 7.0, Color("#f5d598"))
    draw_arc(Vector2.ZERO, interaction_radius, 0.0, TAU, 64, Color(0.94, 0.75, 0.26, 0.35), 1.5)
