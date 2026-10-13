extends CharacterBody2D
## Movimentação, colisão e animações da protagonista.

const WALK_SPEED: float = 240.0
const COLLISION_RADIUS: float = 16.0
const TARGET_FRAME_HEIGHT: float = 180.0
const WALK_FPS: float = 7.0
const EXPRESSION_FPS: float = 7.0
const LOOK_BACK_FPS: float = 3.0
const EXPRESSION_DELAY_MIN: float = 3.0
const EXPRESSION_DELAY_MAX: float = 6.0
const BLINK_PRIORITY: float = 0.85
const SPRITE_DIRECTORY: String = "res://assets/characters/princess/"

var movement_enabled: bool = true
var facing: Vector2 = Vector2.DOWN
@onready var _sprite: AnimatedSprite2D = $PrincessAnimatedSprite
@onready var _expression_timer: Timer = $ExpressionTimer
var _next_expression_delay: float = 0.0
var _random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	collision_layer = 1
	collision_mask = 1
	_random.randomize()
	_sprite.animation_finished.connect(_on_animation_finished)
	_expression_timer.timeout.connect(_on_expression_timeout)
	_sprite.play("idle")
	var idle_frame: Texture2D = _sprite.sprite_frames.get_frame_texture("idle", 0)
	if idle_frame != null and idle_frame.get_height() > 0:
		_sprite.scale = Vector2.ONE * TARGET_FRAME_HEIGHT / float(idle_frame.get_height())
	_schedule_expression()
	queue_redraw()

func _schedule_expression() -> void:
	_next_expression_delay = _random.randf_range(EXPRESSION_DELAY_MIN, EXPRESSION_DELAY_MAX)
	_expression_timer.start(_next_expression_delay)

func _on_expression_timeout() -> void:
	if velocity.length_squared() > 0.01 or _sprite.animation != "idle":
		_schedule_expression()
		return
	var expression: StringName = "blink" if _random.randf() < BLINK_PRIORITY else "look_back"
	_sprite.play(expression)

func _on_animation_finished() -> void:
	if _sprite.animation != "blink" and _sprite.animation != "look_back":
		return
	_sprite.play("idle")
	var idle_frame: Texture2D = _sprite.sprite_frames.get_frame_texture("idle", 0)
	if idle_frame != null and idle_frame.get_height() > 0:
		_sprite.scale = Vector2.ONE * TARGET_FRAME_HEIGHT / float(idle_frame.get_height())
	_schedule_expression()

func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	if movement_enabled:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * WALK_SPEED
	if direction.length_squared() > 0.01:
		facing = direction
		_expression_timer.stop()
		_play_walk_animation(direction)
	elif _is_walk_animation(_sprite.animation):
		_sprite.play("idle")
		_schedule_expression()
	move_and_slide()

func _play_walk_animation(direction: Vector2) -> void:
	var preferred_animation: StringName
	if absf(direction.x) >= absf(direction.y):
		preferred_animation = "walk_left" if direction.x < 0.0 else "walk_right"
	else:
		preferred_animation = "walk_up" if direction.y < 0.0 else "walk_down"
	var has_directional_frames: bool = _sprite.sprite_frames.has_animation(preferred_animation) and _sprite.sprite_frames.get_frame_count(preferred_animation) > 0
	var selected_animation: StringName = preferred_animation if has_directional_frames else "walk"
	if _sprite.animation != selected_animation:
		_sprite.play(selected_animation)
	_sprite.flip_h = not has_directional_frames and direction.x < -0.01

func _is_walk_animation(animation_name: StringName) -> bool:
	return animation_name == "walk" or str(animation_name).begins_with("walk_")

func _draw() -> void:
	# Sombra rasa e próxima ao contato com o chão; nunca amplia o personagem.
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for i in range(32):
		var angle := float(i) * TAU / 32.0
		outer.append(Vector2(cos(angle) * 20.0, 2.0 + sin(angle) * 6.0))
		inner.append(Vector2(cos(angle) * 12.0, 1.0 + sin(angle) * 3.5))
	draw_colored_polygon(outer, Color(0.19, 0.13, 0.20, 0.12))
	draw_colored_polygon(inner, Color(0.17, 0.12, 0.18, 0.10))
