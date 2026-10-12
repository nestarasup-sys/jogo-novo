extends CharacterBody2D
## Movimentação, colisão e animações da protagonista.

const WALK_SPEED: float = 240.0
const COLLISION_RADIUS: float = 16.0
const TARGET_FRAME_HEIGHT: float = 150.0
const WALK_FPS: float = 7.0
const EXPRESSION_FPS: float = 7.0
const LOOK_BACK_FPS: float = 3.0
const EXPRESSION_DELAY_MIN: float = 3.0
const EXPRESSION_DELAY_MAX: float = 6.0
const BLINK_PRIORITY: float = 0.85
const SPRITE_DIRECTORY: String = "res://assets/characters/princess/"

var movement_enabled: bool = true
var facing: Vector2 = Vector2.DOWN
var _sprite: AnimatedSprite2D
var _expression_timer: Timer
var _next_expression_delay: float = 0.0
var _random: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	collision_layer = 1
	collision_mask = 1
	_add_foot_collider()
	_setup_sprite()
	_setup_expression_timer()
	queue_redraw()

func _add_foot_collider() -> void:
	var shape := CircleShape2D.new()
	shape.radius = COLLISION_RADIUS
	var collider := CollisionShape2D.new()
	collider.name = "FootCollisionShape"
	collider.shape = shape
	add_child(collider)

func _setup_sprite() -> void:
	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")

	_add_animation(frames, "idle", ["idle.png"], 1.0, true)
	_add_animation(frames, "blink", ["idle.png", "blink.png", "idle.png"], EXPRESSION_FPS, false)
	_add_animation(frames, "look_back", ["idle.png", "look_back.png", "idle.png"], LOOK_BACK_FPS, false)
	_add_animation(frames, "walk", ["walk_01.png", "walk_02.png", "walk_03.png", "walk_02.png"], WALK_FPS, true)

	var idle_texture := frames.get_frame_texture("idle", 0)
	if idle_texture == null:
		push_error("Não foi possível carregar o sprite idle da protagonista.")
		return

	_sprite = AnimatedSprite2D.new()
	_sprite.name = "PrincessAnimatedSprite"
	_sprite.sprite_frames = frames
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var visual_scale: float = TARGET_FRAME_HEIGHT / idle_texture.get_height()
	_sprite.scale = Vector2.ONE * visual_scale
	_sprite.position = Vector2(0.0, -idle_texture.get_height() * visual_scale * 0.5)
	_sprite.animation_finished.connect(_on_animation_finished)
	add_child(_sprite)
	_sprite.play("idle")

func _add_animation(frames: SpriteFrames, animation_name: StringName, filenames: Array[String], fps: float, looped: bool) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, looped)
	for filename in filenames:
		var path: String = SPRITE_DIRECTORY + filename
		var texture := load(path) as Texture2D
		if texture == null:
			push_error("Imagem da protagonista ausente: " + path)
			continue
		frames.add_frame(animation_name, texture)

func _setup_expression_timer() -> void:
	_random.randomize()
	_expression_timer = Timer.new()
	_expression_timer.name = "ExpressionTimer"
	_expression_timer.one_shot = true
	_expression_timer.timeout.connect(_on_expression_timeout)
	add_child(_expression_timer)
	_schedule_expression()

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
	# A origem do corpo fica nos pés; a sombra segue esse ponto.
	draw_circle(Vector2(0.0, 11.0), 15.0, Color(0.22, 0.14, 0.21, 0.22))
