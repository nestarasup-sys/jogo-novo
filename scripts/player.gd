extends CharacterBody2D
## Jogador placeholder, movimentação top-down em 8 direções e colisão.

const WALK_SPEED: float = 240.0
var movement_enabled: bool = true
var facing: Vector2 = Vector2.DOWN

func _ready() -> void:
    collision_layer = 1
    collision_mask = 1
    var shape := CircleShape2D.new()
    shape.radius = 16.0
    var collider := CollisionShape2D.new()
    collider.shape = shape
    add_child(collider)
    queue_redraw()

func _physics_process(_delta: float) -> void:
    var direction := Vector2.ZERO
    if movement_enabled:
        direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * WALK_SPEED
    if direction.length_squared() > 0.01:
        facing = direction
    move_and_slide()
    queue_redraw()

func _draw() -> void:
    draw_circle(Vector2(0, 14), 19, Color(Color("#735d70"), 0.30))
    draw_colored_polygon(PackedVector2Array([
        Vector2(-19, 8), Vector2(19, 8), Vector2(24, 28), Vector2(-24, 28)
    ]), Color("#9a5a86"))
    draw_circle(Vector2(0, -5), 14, Color("#f1ccab"))
    draw_arc(Vector2(0, -8), 13, PI, TAU, 16, Color("#573d43"), 7.0)
    var look := facing.normalized() * 5.0
    draw_circle(Vector2(-4, -5) + look * 0.4, 1.7, Color("#4b3b48"))
    draw_circle(Vector2(4, -5) + look * 0.4, 1.7, Color("#4b3b48"))
