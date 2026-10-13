@tool
extends StaticBody2D
## Móvel de cena editável. Footprint é um CollisionShape2D persistido na .tscn.
## Mudar arte no Inspector não muda a colisão; mudar footprint_size sim.

@export var display_name: String = "MÓVEL":
    set(value):
        display_name = value
        queue_redraw()
@export var footprint_size: Vector2 = Vector2(100.0, 70.0):
    set(value):
        footprint_size = value
        _sync_footprint()
        queue_redraw()
@export var placeholder_color: Color = Color("#8e7582"):
    set(value):
        placeholder_color = value
        queue_redraw()
@export var art_texture: Texture2D:
    set(value):
        art_texture = value
        queue_redraw()
@export var art_size: Vector2 = Vector2.ZERO:
    set(value):
        art_size = value
        queue_redraw()
@export var art_offset: Vector2 = Vector2.ZERO:
    set(value):
        art_offset = value
        queue_redraw()
@export var is_solid: bool = true:
    set(value):
        is_solid = value
        _sync_footprint()

func _ready() -> void:
    _sync_footprint()
    queue_redraw()

func _sync_footprint() -> void:
    collision_layer = 1 if is_solid else 0
    collision_mask = 0
    if not is_inside_tree():
        return
    var footprint: CollisionShape2D = get_node_or_null("Footprint") as CollisionShape2D
    if footprint == null:
        push_warning("Móvel sem Footprint: " + name)
        return
    footprint.disabled = not is_solid
    if footprint.shape is RectangleShape2D:
        (footprint.shape as RectangleShape2D).size = footprint_size

func _draw() -> void:
    if art_texture != null:
        var size: Vector2 = art_size if art_size != Vector2.ZERO else art_texture.get_size()
        var rect := Rect2(Vector2(-size.x * 0.5, -size.y + footprint_size.y * 0.5) + art_offset, size)
        draw_texture_rect(art_texture, rect, false)
    else:
        var rect := Rect2(-footprint_size * 0.5, footprint_size)
        draw_rect(rect, placeholder_color)
        draw_rect(rect, Color("#554755"), false, 3.0)
        if not display_name.is_empty():
            draw_string(ThemeDB.fallback_font, Vector2(-footprint_size.x * 0.5 + 6.0, 0.0), display_name, HORIZONTAL_ALIGNMENT_LEFT, int(footprint_size.x - 10.0), 14, Color.WHITE)
