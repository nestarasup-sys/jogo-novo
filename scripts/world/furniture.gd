extends StaticBody2D
## Móvel individual no editor. Sprite e footprint de colisão são independentes.

@export var display_name: String = "MÓVEL"
@export var footprint_size: Vector2 = Vector2(100.0, 70.0)
@export var placeholder_color: Color = Color("#8e7582")
@export var art_texture: Texture2D
@export var art_size: Vector2 = Vector2.ZERO
@export var art_offset: Vector2 = Vector2.ZERO
@export var is_solid: bool = true

func _ready() -> void:
    collision_layer = 1 if is_solid else 0
    collision_mask = 0
    if is_solid:
        var collider := CollisionShape2D.new()
        collider.name = "Footprint"
        var rectangle := RectangleShape2D.new()
        rectangle.size = footprint_size
        collider.shape = rectangle
        add_child(collider)
    queue_redraw()

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
