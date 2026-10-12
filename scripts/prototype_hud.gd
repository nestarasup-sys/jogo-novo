extends CanvasLayer
## HUD simples: localização, dica contextual e painel de interação.

var title_label: Label
var prompt_label: Label
var overlay: Control
var message_label: Label
var message_title: Label
var _open: bool = false
var prompt_text: String = ""

func _ready() -> void:
    layer = 1
    var root := Control.new()
    root.name = "HudRoot"
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    root.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(root)
    title_label = _label(root, Vector2(32, 28), 28, Color("#493846"))
    var guide := _label(root, Vector2(32, 70), 17, Color("#5b5059"))
    guide.text = "WASD / setas: mover   •   E / espaço: interagir"
    prompt_label = _label(root, Vector2(390, 650), 23, Color("#fff7e7"))
    prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    prompt_label.add_theme_color_override("font_shadow_color", Color("#372735"))
    prompt_label.add_theme_constant_override("shadow_offset_x", 2)
    prompt_label.add_theme_constant_override("shadow_offset_y", 2)
    overlay = Control.new()
    overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    root.add_child(overlay)
    var dim := ColorRect.new()
    dim.color = Color(0.09, 0.06, 0.13, 0.55)
    dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
    overlay.add_child(dim)
    var box := ColorRect.new()
    box.name = "MessageBox"
    box.color = Color("#f2e6d5")
    box.mouse_filter = Control.MOUSE_FILTER_IGNORE
    overlay.add_child(box)
    message_title = _label(box, Vector2(26, 19), 26, Color("#543d4d"))
    message_label = _label(box, Vector2(26, 64), 21, Color("#594c51"))
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    var footer := _label(box, Vector2(26, 146), 17, Color("#746770"))
    footer.text = "E / ESPAÇO / AÇÃO / ESC — fechar"
    overlay.visible = false
    get_viewport().size_changed.connect(_layout)
    _layout()

func _label(parent: Node, at: Vector2, size: int, color: Color) -> Label:
    var text := Label.new()
    text.position = at
    text.add_theme_font_size_override("font_size", size)
    text.add_theme_color_override("font_color", color)
    text.mouse_filter = Control.MOUSE_FILTER_IGNORE
    parent.add_child(text)
    return text

func _layout() -> void:
    var screen := get_viewport().get_visible_rect().size
    prompt_label.position = Vector2(screen.x * 0.5 - 300, screen.y - 66)
    prompt_label.size = Vector2(600, 50)
    var box: ColorRect = overlay.get_node("MessageBox") as ColorRect
    box.position = screen * 0.5 - Vector2(345, 110)
    box.size = Vector2(690, 220)
    message_label.size = Vector2(638, 78)

func set_location(label: String) -> void:
    title_label.text = label

func set_prompt(label: String) -> void:
    if label == prompt_text:
        return
    prompt_text = label
    prompt_label.text = label

func is_message_open() -> bool:
    return _open

func show_message(title: String, text: String) -> void:
    _open = true
    message_title.text = title
    message_label.text = text
    overlay.visible = true
    set_prompt("")

func close_message() -> void:
    _open = false
    overlay.visible = false
