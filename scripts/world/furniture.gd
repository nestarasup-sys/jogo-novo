@tool
extends StaticBody2D
## Móvel de cena editável. Footprint é um CollisionShape2D persistido na .tscn.
## Mudar arte no Inspector não muda a colisão; mudar footprint_size sim.

@export var display_name: String = "MÓVEL":
    set(value):
        display_name = value
		_redraw_art()
@export var footprint_size: Vector2 = Vector2(100.0, 70.0):
    set(value):
        footprint_size = value
        _sync_footprint()
		_redraw_art()
@export var placeholder_color: Color = Color("#8e7582"):
    set(value):
        placeholder_color = value
		_redraw_art()
@export var art_texture: Texture2D:
    set(value):
        art_texture = value
		_redraw_art()
@export var art_size: Vector2 = Vector2.ZERO:
    set(value):
        art_size = value
		_redraw_art()
@export var art_offset: Vector2 = Vector2.ZERO:
    set(value):
        art_offset = value
		_redraw_art()
@export var is_solid: bool = true:
    set(value):
        is_solid = value
        _sync_footprint()

func _ready() -> void:
    _sync_footprint()
	_redraw_art()

func _redraw_art() -> void:
    queue_redraw()
	var visual: CanvasItem = get_node_or_null("Visual") as CanvasItem
	if visual != null:
		visual.queue_redraw()

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
	# A cena usa o filho Visual para que a arte possa ser arrastada separadamente.
	if get_node_or_null("Visual") != null:
		return
    if art_texture != null:
        var size: Vector2 = art_size if art_size != Vector2.ZERO else art_texture.get_size()
        var rect := Rect2(Vector2(-size.x * 0.5, -size.y + footprint_size.y * 0.5) + art_offset, size)
        draw_texture_rect(art_texture, rect, false)
    else:
        # Placeholder elegante, mas ainda temporário: mantém proporção e footprint.
        # O visual não participa da colisão e é substituído por art_texture.
        var rect := Rect2(-footprint_size * 0.5, footprint_size)
        draw_rect(rect, Color("#4a3949"))
        var face := Rect2(rect.position + Vector2(3.0, 3.0), rect.size - Vector2(6.0, 6.0))
        draw_rect(face, placeholder_color)
        draw_rect(Rect2(face.position + Vector2(7.0, 8.0), Vector2(face.size.x - 14.0, 2.0)), Color(1.0, 0.96, 0.93, 0.34))
        draw_rect(Rect2(face.position + Vector2(8.0, face.size.y - 11.0), Vector2(face.size.x - 16.0, 2.0)), Color(0.25, 0.19, 0.29, 0.28))
        draw_rect(Rect2(face.position + Vector2(7.0, 7.0), face.size - Vector2(14.0, 14.0)), Color(0.95, 0.87, 0.80, 0.30), false, 1.0)
        if not display_name.is_empty():
            draw_string(ThemeDB.fallback_font,
                Vector2(face.position.x + 9.0, face.position.y + face.size.y * 0.5 + 5.0),
                display_name, HORIZONTAL_ALIGNMENT_CENTER, int(face.size.x - 18.0), 15,
                Color("#fff5e9"))
            draw_circle(Vector2(0.0, face.position.y + 17.0), 2.5, Color("#e1c19c"))
