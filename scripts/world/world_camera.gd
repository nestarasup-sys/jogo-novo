extends Camera2D
## Zoom é escala visual, não muda física nem tamanhos dos sprites.

@export_range(0.75, 2.0, 0.05) var world_zoom: float = 1.30

func _ready() -> void:
    zoom = Vector2.ONE * world_zoom
    position_smoothing_enabled = false
    make_current()

func set_room_size(size: Vector2) -> void:
    limit_left = 0
    limit_top = 0
    limit_right = int(size.x)
    limit_bottom = int(size.y)
