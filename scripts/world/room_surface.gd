extends Node2D
## Fundo/parede independentes de móveis, lógica e colisão. Troque textura pelo Inspector.

@export var surface_size: Vector2 = Vector2(1280.0, 720.0)
@export_range(0.0, 720.0, 1.0) var wall_height: float = 260.0
@export var floor_color: Color = Color("#e6d9cc")
@export var wall_color: Color = Color("#c5b8d4")
@export var floor_texture: Texture2D
@export var wall_texture: Texture2D
@export var show_trim: bool = true

func _ready() -> void:
    texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
    queue_redraw()

func _draw() -> void:
    var wall_h: float = clampf(wall_height, 0.0, surface_size.y)
    var floor_rect := Rect2(0.0, wall_h, surface_size.x, surface_size.y - wall_h)
    var wall_rect := Rect2(0.0, 0.0, surface_size.x, wall_h)
    draw_rect(Rect2(Vector2.ZERO, surface_size), floor_color)
    if floor_texture != null and floor_rect.size.y > 0.0:
        draw_texture_rect(floor_texture, floor_rect, true)
    if wall_h > 0.0:
        draw_rect(wall_rect, wall_color)
        if wall_texture != null:
            draw_texture_rect(wall_texture, wall_rect, true)
        if show_trim:
            draw_rect(Rect2(0.0, wall_h - 7.0, surface_size.x, 10.0), Color("#524653"))
            draw_line(Vector2(0.0, wall_h + 3.0), Vector2(surface_size.x, wall_h + 3.0), Color("#c4a7a4"), 2.0)
