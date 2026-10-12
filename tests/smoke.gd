extends SceneTree
## Rodar: godot --headless --path . --script res://tests/smoke.gd

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const MOVE_FRAMES: int = 12

var failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_scene_graph()
	await _test_playable_prototype()
	if failures.is_empty():
		print("PASS: personagem animada, movimento, colisões, interações, portas e multitouch")
		quit(0)
	else:
		push_error("FAIL: %d verificações" % failures.size())
		for failure in failures:
			push_error("  - " + failure)
		quit(1)

func _test_scene_graph() -> void:
	var paths := {
		"bedroom": "res://scenes/maps/bedroom.tscn",
		"corridor": "res://scenes/maps/corridor.tscn",
		"garden": "res://scenes/maps/garden.tscn"
	}
	var expected := {
		"bedroom": ["corridor"],
		"corridor": ["bedroom", "garden"],
		"garden": ["corridor"]
	}
	for map_id in paths:
		var scene: PackedScene = load(paths[map_id])
		_expect(scene != null, "cena carregável: " + map_id)
		if scene == null:
			continue
		var map: Node = scene.instantiate()
		root.add_child(map)
		var outgoing: Array[String] = []
		for interaction in map.interactions:
			if interaction["kind"] != "door":
				continue
			outgoing.append(interaction["target"])
			_expect(paths.has(interaction["target"]), "destino de porta válido em " + map_id)
			var spawn: Vector2 = interaction["spawn"]
			_expect(spawn.x >= 50.0 and spawn.x <= 1230.0 and spawn.y >= 50.0 and spawn.y <= 670.0,
				"spawn dentro dos limites em " + map_id)
		outgoing.sort()
		var intended: Array = expected[map_id].duplicate()
		intended.sort()
		_expect(outgoing == intended, "grafo de portas correto em " + map_id)
		map.free()

func _test_player_animations(player: CharacterBody2D, sprite: AnimatedSprite2D) -> void:
	var frames := sprite.sprite_frames
	_expect(frames != null, "SpriteFrames está atribuído")
	if frames == null:
		return
	_expect(sprite.animation == "idle", "protagonista inicia em IDLE")
	_expect_animation_frames(frames, "idle", PackedStringArray(["idle.png"]))
	_expect_animation_frames(frames, "blink", PackedStringArray(["idle.png", "blink.png", "idle.png"]))
	_expect_animation_frames(frames, "look_back", PackedStringArray(["idle.png", "look_back.png", "idle.png"]))
	_expect_animation_frames(frames, "walk", PackedStringArray(["walk_01.png", "walk_02.png", "walk_03.png", "walk_02.png"]))
	_expect(frames.get_animation_loop("idle"), "IDLE permanece em loop")
	_expect(not frames.get_animation_loop("blink") and not frames.get_animation_loop("look_back"), "expressões são animações de passagem única")
	_expect(frames.get_animation_loop("walk") and is_equal_approx(frames.get_animation_speed("walk"), 7.0), "WALK repete a 7 FPS")
	_expect(sprite.texture_filter == CanvasItem.TEXTURE_FILTER_LINEAR, "arte usa filtragem linear")
	var idle_texture := frames.get_frame_texture("idle", 0)
	if idle_texture != null:
		_expect(absf(idle_texture.get_height() * sprite.scale.y - 150.0) < 0.5, "quadro da protagonista mede aproximadamente 150 px")
		_expect(absf(sprite.position.y + idle_texture.get_height() * sprite.scale.y * 0.5) < 0.1, "base do sprite fica alinhada à origem dos pés")
	var collision := player.get_node_or_null("FootCollisionShape") as CollisionShape2D
	var circle := collision.shape as CircleShape2D if collision != null else null
	_expect(circle != null and is_equal_approx(circle.radius, 16.0), "colisão continua circular e concentrada nos pés")
	var timer := player.get_node_or_null("ExpressionTimer") as Timer
	_expect(timer != null and timer.one_shot, "expressões usam temporizador de uma passagem")
	if timer != null:
		var delay: float = float(player.get("_next_expression_delay"))
		_expect(delay >= 3.0 and delay <= 6.0, "intervalo de expressão fica entre 3 e 6 segundos")
		timer.stop()
	sprite.play("blink")
	await sprite.animation_finished
	_expect(sprite.animation == "idle", "BLINK retorna a IDLE")
	if timer != null:
		timer.stop()
	sprite.play("look_back")
	await sprite.animation_finished
	_expect(sprite.animation == "idle", "LOOK_BACK retorna a IDLE")
	if timer != null:
		timer.stop()
	player.call("_on_expression_timeout")
	_expect(sprite.animation == "blink" or sprite.animation == "look_back", "temporizador inicia uma expressão ocasional")
	await sprite.animation_finished
	_expect(sprite.animation == "idle", "expressão ocasional não trava o estado IDLE")
	if timer != null:
		timer.stop()

func _expect_animation_frames(frames: SpriteFrames, animation_name: StringName, expected_files: PackedStringArray) -> void:
	_expect(frames.has_animation(animation_name), "SpriteFrames contém " + str(animation_name))
	if not frames.has_animation(animation_name):
		return
	var frame_count: int = frames.get_frame_count(animation_name)
	_expect(frame_count == expected_files.size(), str(animation_name) + " tem a quantidade de quadros esperada")
	for frame_index in range(mini(frame_count, expected_files.size())):
		var texture := frames.get_frame_texture(animation_name, frame_index)
		_expect(texture != null and texture.resource_path.ends_with(expected_files[frame_index]), str(animation_name) + " quadro " + str(frame_index + 1) + " usa " + expected_files[frame_index])

func _test_playable_prototype() -> void:
	root.size = Vector2i(1280, 720)
	var game: Node2D = MAIN_SCENE.instantiate()
	root.add_child(game)
	await process_frame
	await physics_frame
	_expect(game.current_map_id == "bedroom", "inicia no quarto")
	# Zoom de mundo não deve exigir aumentar escala do sprite ou colisões.
	var camera: Camera2D = game.player.get_node_or_null("WorldCamera") as Camera2D
	_expect(camera != null, "câmera de mundo existe")
	if camera != null:
		_expect(is_equal_approx(camera.zoom.x, 1.30) and is_equal_approx(camera.zoom.y, 1.30),
			"mundo ampliado uniformemente em 30%")
		_expect(camera.limit_left == 0 and camera.limit_top == 0 and camera.limit_right == 1280 and camera.limit_bottom == 720,
			"limites de câmera correspondem ao mapa")

	_expect(game.player.global_position.distance_to(Vector2(640, 420)) < 1.0, "spawn inicial acessível")
	_expect(InputMap.has_action("move_right") and InputMap.has_action("interact"), "ações de teclado registradas")
	var animated_sprite := game.player.get_node_or_null("PrincessAnimatedSprite") as AnimatedSprite2D
	_expect(animated_sprite != null, "protagonista usa AnimatedSprite2D")
	if animated_sprite != null:
		await _test_player_animations(game.player, animated_sprite)

	# Movimento em eixo e diagonal mantém a mesma velocidade resultante.
	game.player.global_position = Vector2(600, 360)
	await _release_all_inputs()
	Input.action_press("move_right")
	await _physics_frames(MOVE_FRAMES)
	if animated_sprite != null:
		_expect(animated_sprite.animation == "walk" and animated_sprite.is_playing(), "movimento inicia a animação WALK")
		_expect(not animated_sprite.flip_h, "movimento para a direita usa o sprite sem espelhamento")
	Input.action_release("move_right")
	await physics_frame
	if animated_sprite != null:
		_expect(animated_sprite.animation == "idle", "soltar as teclas volta imediatamente para IDLE")
	var axis_distance: float = game.player.global_position.distance_to(Vector2(600, 360))
	_expect(axis_distance > 25.0 and axis_distance < 60.0, "movimento horizontal responde ao input")
	game.player.global_position = Vector2(600, 360)
	await _release_all_inputs()
	Input.action_press("move_left")
	await _physics_frames(2)
	if animated_sprite != null:
		_expect(animated_sprite.animation == "walk" and animated_sprite.flip_h, "movimento para a esquerda espelha WALK horizontalmente")
	Input.action_release("move_left")
	await physics_frame

	game.player.global_position = Vector2(600, 360)
	await _release_all_inputs()
	Input.action_press("move_right")
	Input.action_press("move_down")
	await _physics_frames(MOVE_FRAMES)
	Input.action_release("move_right")
	Input.action_release("move_down")
	var diagonal_delta: Vector2 = game.player.global_position - Vector2(600, 360)
	_expect(absf(diagonal_delta.x - diagonal_delta.y) < 3.0, "diagonal tem componentes equilibradas")
	_expect(absf(diagonal_delta.length() - axis_distance) < 5.0, "diagonal não fica mais rápida que movimento em eixo")
	if animated_sprite != null:
		_expect(animated_sprite.animation == "walk", "diagonal também mantém WALK")

	# A escrivaninha é um obstáculo sólido; o jogador deve parar antes de atravessá-la.
	game.player.global_position = Vector2(790, 250)
	await _release_all_inputs()
	Input.action_press("move_right")
	await _physics_frames(40)
	Input.action_release("move_right")
	_expect(game.player.global_position.x >= 790.0 and game.player.global_position.x < 801.0,
		"colisão impede atravessar a escrivaninha")
	game.player.global_position = Vector2(60, 360)
	await _release_all_inputs()
	Input.action_press("move_left")
	await _physics_frames(30)
	Input.action_release("move_left")
	_expect(game.player.global_position.x >= 49.0, "colisão impede sair pelo limite do mapa")

	# Interação só aparece dentro do raio e a janela bloqueia movimento até fechar.
	game.player.global_position = Vector2(600, 420)
	await _release_all_inputs()
	_expect(game.current_map.nearest_interaction(game.player.global_position).is_empty(),
		"interação não aparece fora do alcance")
	game.player.global_position = Vector2(445, 281)
	var nearby: Dictionary = game.current_map.nearest_interaction(game.player.global_position)
	_expect(not nearby.is_empty() and nearby["label"] == "Examinar cama", "alvo próximo é selecionado")
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	_expect(game.hud.is_message_open() and game.hud.overlay.visible, "interação abre a janela")
	await process_frame
	_expect(not game.player.movement_enabled, "janela bloqueia movimento")
	var stopped_at: Vector2 = game.player.global_position
	Input.action_press("move_right")
	await _physics_frames(5)
	Input.action_release("move_right")
	_expect(game.player.global_position.distance_to(stopped_at) < 0.1, "jogador não se move com janela aberta")
	await _close_message_with(game, "interact")
	_expect(not game.hud.is_message_open() and not game.hud.overlay.visible, "ação fecha a janela")
	_expect(game.player.movement_enabled, "movimento reativa após fechar a janela")

	await _release_all_inputs()
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	_expect(game.hud.is_message_open(), "janela pode ser reaberta")
	await _close_message_with(game, "close_message")
	_expect(not game.hud.is_message_open(), "Esc fecha a janela")

	# Percurso completo sem trocar de mapa automaticamente ao chegar.
	await _use_interaction_at(game, Vector2(640, 624))
	_expect(game.current_map_id == "corridor", "quarto leva ao corredor")
	_expect(game.player.global_position.distance_to(Vector2(640, 166)) < 1.0, "spawn do corredor fica no lado do quarto")
	await _use_interaction_at(game, Vector2(640, 620))
	_expect(game.current_map_id == "garden", "porta inferior do corredor leva ao jardim")
	_expect(game.player.global_position.distance_to(Vector2(640, 158)) < 1.0, "spawn do jardim fica junto à saída")
	await _use_interaction_at(game, Vector2(640, 112))
	_expect(game.current_map_id == "corridor", "jardim retorna ao corredor")
	game.player.global_position = Vector2(640, 545)
	await _release_all_inputs()
	Input.action_press("move_up")
	await _physics_frames(96)
	Input.action_release("move_up")
	_expect(game.player.global_position.y < 190.0, "corredor permite alcançar a porta do quarto")
	await _use_interaction_at(game, Vector2(640, 112))
	_expect(game.current_map_id == "bedroom", "corredor retorna ao quarto")

	# Os botões têm ações válidas e aceitam dois toques direcionais ao mesmo tempo.
	var controls: CanvasLayer = game.controls
	_expect(controls.buttons.size() == 5, "quatro direções e ação virtual foram criadas")
	_expect(controls.buttons.has("move_left") and controls.buttons.has("move_right") and controls.buttons.has("move_up") and controls.buttons.has("move_down") and controls.buttons.has("interact"),
		"controles virtuais usam o mesmo InputMap do teclado")
	_expect(controls.visible == OS.has_feature("mobile"), "visibilidade inicial acompanha a plataforma")
	controls.visible = true
	controls._layout()
	var right_button: TouchScreenButton = controls.buttons["move_right"]
	var down_button: TouchScreenButton = controls.buttons["move_down"]
	var action_button: TouchScreenButton = controls.buttons["interact"]
	var right_center: Vector2 = right_button.get_global_transform_with_canvas() * Vector2(56, 56)
	var down_center: Vector2 = down_button.get_global_transform_with_canvas() * Vector2(56, 56)
	var action_center: Vector2 = action_button.get_global_transform_with_canvas() * Vector2(56, 56)
	var view_size: Vector2 = game.get_viewport().get_visible_rect().size
	for action_name in controls.buttons:
		var button: TouchScreenButton = controls.buttons[action_name]
		var center: Vector2 = button.get_global_transform_with_canvas() * Vector2(56, 56)
		_expect(Rect2(Vector2.ZERO, view_size).has_point(center), "botão virtual dentro da tela: " + action_name)
	var right_touch := InputEventScreenTouch.new()
	right_touch.index = 0
	right_touch.position = right_center
	right_touch.pressed = true
	var down_touch := InputEventScreenTouch.new()
	down_touch.index = 1
	down_touch.position = down_center
	down_touch.pressed = true
	Input.parse_input_event(right_touch)
	await process_frame
	Input.parse_input_event(down_touch)
	await process_frame
	_expect(Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"),
		"toques simultâneos ativam movimento diagonal")
	var right_release := InputEventScreenTouch.new()
	right_release.index = 0
	right_release.position = right_center
	var down_release := InputEventScreenTouch.new()
	down_release.index = 1
	down_release.position = down_center
	Input.parse_input_event(right_release)
	Input.parse_input_event(down_release)
	await process_frame
	_expect(not Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_down"),
		"soltar os dois controles encerra os inputs")
	game.player.global_position = Vector2(445, 281)
	var action_touch := InputEventScreenTouch.new()
	action_touch.index = 0
	action_touch.position = action_center
	action_touch.pressed = true
	Input.parse_input_event(action_touch)
	await process_frame
	await process_frame
	_expect(game.hud.is_message_open(), "botão virtual A abre a interação próxima")
	var action_release := InputEventScreenTouch.new()
	action_release.index = 0
	action_release.position = action_center
	Input.parse_input_event(action_release)
	await process_frame
	await process_frame
	var action_close := InputEventScreenTouch.new()
	action_close.index = 0
	action_close.position = action_center
	action_close.pressed = true
	Input.parse_input_event(action_close)
	await process_frame
	await process_frame
	_expect(not game.hud.is_message_open(), "botão virtual A fecha a interação")
	var action_close_release := InputEventScreenTouch.new()
	action_close_release.index = 0
	action_close_release.position = action_center
	Input.parse_input_event(action_close_release)
	await process_frame
	controls.visible = false
	game.queue_free()
	await process_frame
	await _release_all_inputs()

func _use_interaction_at(game: Node2D, position: Vector2) -> void:
	game.player.global_position = position
	await _release_all_inputs()
	var nearby: Dictionary = game.current_map.nearest_interaction(position)
	_expect(not nearby.is_empty(), "há interação acessível em " + game.current_map_id)
	_expect(nearby.get("kind", "") == "door", "alvo próximo é uma porta em " + game.current_map_id)
	Input.action_press("interact")
	await process_frame
	Input.action_release("interact")
	await process_frame
	await physics_frame

func _close_message_with(game: Node2D, action: String) -> void:
	await _release_all_inputs()
	Input.action_press(action)
	await process_frame
	Input.action_release(action)
	await process_frame
	await physics_frame

func _release_all_inputs() -> void:
	for action in ["move_left", "move_right", "move_up", "move_down", "interact", "close_message"]:
		Input.action_release(action)
	await process_frame

func _physics_frames(count: int) -> void:
	for _frame in range(count):
		await physics_frame

func _expect(condition: bool, description: String) -> void:
	if not condition:
		failures.append(description)
