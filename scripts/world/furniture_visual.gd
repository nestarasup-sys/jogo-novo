@tool
extends Node2D
## Camada de arte destacada: pode ser arrastada sem alterar a colisão.

func _draw() -> void:
	var furniture: Node = get_parent()
	if furniture == null:
		return
	var texture: Texture2D = furniture.get("art_texture")
	var footprint: Vector2 = furniture.get("footprint_size")
	var art_size: Vector2 = furniture.get("art_size")
	var art_offset: Vector2 = furniture.get("art_offset")
	if texture != null:
		var size: Vector2 = art_size if art_size != Vector2.ZERO else texture.get_size()
		var texture_rect := Rect2(Vector2(-size.x * 0.5, -size.y + footprint.y * 0.5) + art_offset, size)
		draw_texture_rect(texture, texture_rect, false)
		return

	var placeholder_rect := Rect2(-footprint * 0.5, footprint)
	draw_rect(placeholder_rect, Color("#4a3949"))
	var face := Rect2(placeholder_rect.position + Vector2(3.0, 3.0), placeholder_rect.size - Vector2(6.0, 6.0))
	var placeholder_color: Color = furniture.get("placeholder_color")
	draw_rect(face, placeholder_color)
	draw_rect(
		Rect2(face.position + Vector2(7.0, 8.0), Vector2(face.size.x - 14.0, 2.0)),
		Color(1.0, 0.96, 0.93, 0.34)
	)
	draw_rect(
		Rect2(face.position + Vector2(8.0, face.size.y - 11.0), Vector2(face.size.x - 16.0, 2.0)),
		Color(0.25, 0.19, 0.29, 0.28)
	)
	draw_rect(Rect2(face.position + Vector2(7.0, 7.0), face.size - Vector2(14.0, 14.0)),
		Color(0.95, 0.87, 0.80, 0.30), false, 1.0)
	var display_name: String = str(furniture.get("display_name"))
	if not display_name.is_empty():
		draw_string(
			ThemeDB.fallback_font,
			Vector2(face.position.x + 9.0, face.position.y + face.size.y * 0.5 + 5.0),
			display_name,
			HORIZONTAL_ALIGNMENT_CENTER,
			int(face.size.x - 18.0),
			15,
			Color("#fff5e9")
		)
		draw_circle(Vector2(0.0, face.position.y + 17.0), 2.5, Color("#e1c19c"))
