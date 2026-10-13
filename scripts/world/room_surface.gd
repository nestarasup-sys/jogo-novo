@tool
extends Node2D
## Visual de piso/parede no editor e em execução. Nunca cria nós.

@export var surface_size: Vector2 = Vector2(1280.0, 720.0):
    set(value):
        surface_size = value
        queue_redraw()
@export_range(0.0, 720.0, 1.0) var wall_height: float = 260.0:
    set(value):
        wall_height = value
        queue_redraw()
@export var floor_color: Color = Color("#e6d9cc"):
    set(value):
        floor_color = value
        queue_redraw()
@export var wall_color: Color = Color("#c5b8d4"):
    set(value):
        wall_color = value
        queue_redraw()
@export var floor_texture: Texture2D:
    set(value):
        floor_texture = value
        queue_redraw()
@export var wall_texture: Texture2D:
    set(value):
        wall_texture = value
        queue_redraw()
@export var show_trim: bool = true:
    set(value):
        show_trim = value
        queue_redraw()

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
