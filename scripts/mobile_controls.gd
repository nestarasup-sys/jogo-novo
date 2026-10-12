extends CanvasLayer
## Controles virtuais multitouch Android. F2 mostra/esconde no Windows para inspeção.

const DIAMETER: int = 112
const RADIUS: float = 50.0
var buttons: Dictionary = {}
var normal_texture: ImageTexture
var pressed_texture: ImageTexture

func _ready() -> void:
    layer = 2
    normal_texture = _texture(Color("#403b58"), 0.70)
    pressed_texture = _texture(Color("#977d9f"), 0.90)
    _create_button("move_left", "←")
    _create_button("move_right", "→")
    _create_button("move_up", "↑")
    _create_button("move_down", "↓")
    _create_button("interact", "A")
    visible = OS.has_feature("mobile")
    get_viewport().size_changed.connect(_layout)
    _layout()

func _texture(color: Color, opacity: float) -> ImageTexture:
    var image := Image.create(DIAMETER, DIAMETER, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    for y in range(DIAMETER):
        for x in range(DIAMETER):
            var d := Vector2(float(x - DIAMETER / 2), float(y - DIAMETER / 2)).length()
            if d <= RADIUS:
                var pixel := color
                pixel.a = opacity if d < RADIUS - 5.0 else minf(opacity + 0.13, 1.0)
                image.set_pixel(x, y, pixel)
    return ImageTexture.create_from_image(image)

func _create_button(action_name: String, letter: String) -> void:
    var button := TouchScreenButton.new()
    button.name = action_name
    button.action = action_name
    button.texture_normal = normal_texture
    button.texture_pressed = pressed_texture
    button.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
    var circle := CircleShape2D.new()
    circle.radius = RADIUS
    button.shape = circle
    button.shape_centered = true
    add_child(button)
    var lbl := Label.new()
    lbl.text = letter
    lbl.position = Vector2(0, 30)
    lbl.size = Vector2(DIAMETER, 54)
    lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    lbl.add_theme_font_size_override("font_size", 36)
    lbl.add_theme_color_override("font_color", Color.WHITE)
    lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
    button.add_child(lbl)
    buttons[action_name] = button

func _layout() -> void:
    var size := get_viewport().get_visible_rect().size
    var points := {
        "move_left": Vector2(82, size.y - 135),
        "move_right": Vector2(262, size.y - 135),
        "move_up": Vector2(172, size.y - 225),
        "move_down": Vector2(172, size.y - 45),
        "interact": Vector2(size.x - 130, size.y - 112)
    }
    for action_name in buttons.keys():
        buttons[action_name].position = points[action_name] - Vector2(DIAMETER / 2.0, DIAMETER / 2.0)

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F2:
        visible = not visible
