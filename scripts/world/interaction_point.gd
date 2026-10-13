@tool
extends Marker2D
## A própria cena mostra posição, tipo e raio da interação.

@export_enum("inspect", "door") var interaction_type: String = "inspect":
    set(value):
        interaction_type = value
        queue_redraw()
@export var action_label: String = "Interagir"
@export_multiline var message: String = ""
@export var destination_room: String = ""
@export var destination_spawn: String = ""
@export_range(24.0, 240.0, 1.0) var interaction_radius: float = 94.0:
    set(value):
        interaction_radius = value
        queue_redraw()
@export var enabled: bool = true:
    set(value):
        enabled = value
        queue_redraw()

func get_interaction() -> Dictionary:
    return {
        "kind": interaction_type,
        "label": action_label,
        "message": message,
        "target": destination_room,
        "spawn_id": destination_spawn,
        "source_position": global_position
    }

func _ready() -> void:
    queue_redraw()

func _draw() -> void:
    if not enabled:
        if Engine.is_editor_hint():
            draw_line(Vector2(-10, -10), Vector2(10, 10), Color.RED, 2.0)
            draw_line(Vector2(-10, 10), Vector2(10, -10), Color.RED, 2.0)
        return
    if interaction_type == "door":
        var outline := Rect2(-55.0, -13.0, 110.0, 26.0)
        draw_rect(outline, Color("#8c6055"))
        draw_rect(outline, Color("#f0d0a1"), false, 3.0)
        draw_circle(Vector2.ZERO, 5.0, Color("#ffdea5"))
    elif Engine.is_editor_hint():
        draw_circle(Vector2.ZERO, 9.0, Color("#f5d598"))
    if Engine.is_editor_hint():
        var color := Color(0.97, 0.80, 0.25, 0.55) if interaction_type == "inspect" else Color(0.35, 0.8, 1.0, 0.55)
        draw_arc(Vector2.ZERO, interaction_radius, 0.0, TAU, 64, color, 2.0)
