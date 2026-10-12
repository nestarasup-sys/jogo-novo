extends SceneTree
## Teste smoke da arquitetura modular — Godot 4.7.2 / Windows.
## godot --headless --path . --script res://tests/smoke.gd

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const CATALOG_SCRIPT = preload("res://scripts/world/room_catalog.gd")

var failures: Array[String] = []

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    root.size = Vector2i(1280, 720)
    _test_catalog_and_rooms()
    await _test_gameplay()
    if failures.is_empty():
        print("PASS: catálogo, 3 áreas, componentes, princesa, zoom, colisões, interação e portas")
        quit(0)
    else:
        for failure in failures:
            push_error("FAIL: " + failure)
        quit(1)

func _test_catalog_and_rooms() -> void:
    var catalog = CATALOG_SCRIPT.new()
    if not catalog.load_catalog():
        _expect(false, "catálogo pode ser carregado")
        return
    _expect(catalog.start_room == "bedroom" and catalog.start_spawn == "start", "entrada inicial")
    var expected := {
        "bedroom": ["corridor"],
        "corridor": ["bedroom", "garden"],
        "garden": ["corridor"]
    }
    for room_id in expected:
        var scene: PackedScene = catalog.get_scene(room_id)
        _expect(scene != null, "cena registrada: " + room_id)
        if scene == null:
            continue
        var room = scene.instantiate()
        root.add_child(room)
        _expect(room.room_id == room_id, "room_id confere: " + room_id)
        _expect(room.get_node_or_null("Visual") != null, "visual por ambiente: " + room_id)
        _expect(room.get_node_or_null("WorldSpace/Furniture") != null, "móveis independentes: " + room_id)
        _expect(room.get_node_or_null("Interactions") != null, "interações independentes: " + room_id)
        _expect(room.get_node_or_null("Spawns") != null, "spawns independentes: " + room_id)
        var destinations: Array[String] = []
        for point in room.get_node("Interactions").get_children():
            if point.interaction_type != "door":
                continue
            destinations.append(point.destination_room)
            _expect(expected.has(point.destination_room), "porta aponta para ambiente registrado")
            _expect(not point.destination_spawn.is_empty(), "porta possui spawn de destino")
            if expected.has(point.destination_room):
                var destination_scene: PackedScene = catalog.get_scene(point.destination_room)
                var target_room = destination_scene.instantiate()
                root.add_child(target_room)
                _expect(target_room.get_spawn(point.destination_spawn).x >= 0.0, "spawn da porta existe")
                target_room.free()
        destinations.sort()
        var wanted: Array = expected[room_id].duplicate()
        wanted.sort()
        _expect(destinations == wanted, "grafo de portas: " + room_id)
        _expect(room.get_node("WorldSpace").y_sort_enabled, "Y-sort por ambiente: " + room_id)
        for furniture in room.get_node("WorldSpace/Furniture").get_children():
            if furniture.is_solid:
                _expect(furniture.get_node_or_null("Footprint") != null, "móvel com footprint: " + room_id + "/" + furniture.name)
        _expect(room.get_child_count() >= 5, "ambiente tem estrutura e limites: " + room_id)
        room.free()

func _test_gameplay() -> void:
    var game = MAIN_SCENE.instantiate()
    root.add_child(game)
    await process_frame
    await physics_frame
    _expect(game.current_map_id == "bedroom", "começa no quarto")
    _expect(game.player.get_parent() == game.current_room.get_node("WorldSpace"), "protagonista participa do YSort do cenário")
    _expect(game.player.global_position.distance_to(Vector2(640, 420)) < 0.5, "spawn inicial preservado")
    _expect(InputMap.has_action("move_right") and InputMap.has_action("interact"), "inputs registrados")
    var sprite: AnimatedSprite2D = game.player.get_node_or_null("PrincessAnimatedSprite") as AnimatedSprite2D
    _expect(sprite != null, "sprite oficial da princesa preservado")
    if sprite != null:
        _expect(sprite.sprite_frames.has_animation("walk"), "animação de caminhada preservada")
        _expect(sprite.sprite_frames.get_frame_count("walk") == 4, "ciclo walk_01-02-03-02")
        _expect(sprite.sprite_frames.has_animation("blink"), "animação de piscar preservada")
        _expect(sprite.sprite_frames.has_animation("look_back"), "animação olhar lateral preservada")
    var circle: CollisionShape2D = game.player.get_node_or_null("FootCollisionShape") as CollisionShape2D
    _expect(circle != null and circle.shape is CircleShape2D, "colisão da princesa preservada")
    var cam: Camera2D = game.player.get_node_or_null("WorldCamera") as Camera2D
    _expect(cam != null, "câmera modular")
    if cam != null:
        _expect(is_equal_approx(cam.zoom.x, 1.30) and is_equal_approx(cam.zoom.y, 1.30), "zoom uniforme 130%")
        _expect(cam.limit_right == 1280 and cam.limit_bottom == 720, "limites de câmera")
    _expect(game.current_room.get_node("WorldSpace/Furniture").get_child_count() == 4, "móveis do quarto isolados")
    await _test_player_movement(game)
    game.player.global_position = Vector2(445, 281)
    var bed: Dictionary = game.current_room.nearest_interaction(game.player.global_position)
    _expect(bed.get("kind") == "inspect", "objeto permite inspeção")
    game._activate_interaction(bed)
    _expect(game.hud.is_message_open(), "inspeção abre mensagem")
    game.hud.close_message()
    _expect(not game.hud.is_message_open(), "mensagem fecha")
    var result: bool = game._enter_room("corridor", "from_bedroom")
    _expect(result and game.current_map_id == "corridor", "quarto para corredor")
    result = game._enter_room("garden", "from_corridor")
    _expect(result and game.current_map_id == "garden", "corredor para jardim")
    _expect(game.player.get_parent() == game.current_room.get_node("WorldSpace"), "YSort preservado em transição")
    result = game._enter_room("corridor", "from_garden")
    _expect(result and game.current_map_id == "corridor", "jardim para corredor")
    result = game._enter_room("bedroom", "from_corridor")
    _expect(result and game.current_map_id == "bedroom", "corredor para quarto")
    _expect(game.hud != null and game.hud is CanvasLayer, "HUD fora da câmera")
    game.queue_free()
    await process_frame

func _test_player_movement(game) -> void:
    # Checa o movimento efetivo no motor físico (não só a presença de scripts).
    await _release_inputs()
    game.player.global_position = Vector2(600, 400)
    game.player.velocity = Vector2.ZERO
    Input.action_press("move_right")
    for _i in range(12):
        await physics_frame
    Input.action_release("move_right")
    var axis_distance: float = game.player.global_position.distance_to(Vector2(600, 400))
    _expect(axis_distance > 25.0 and axis_distance < 65.0, "andar para a direita altera a posição")
    await _release_inputs()
    game.player.global_position = Vector2(600, 400)
    game.player.velocity = Vector2.ZERO
    Input.action_press("move_right")
    Input.action_press("move_down")
    for _i in range(12):
        await physics_frame
    Input.action_release("move_right")
    Input.action_release("move_down")
    var delta: Vector2 = game.player.global_position - Vector2(600, 400)
    _expect(absf(delta.x - delta.y) < 3.0, "diagonal equilibrada")
    _expect(absf(delta.length() - axis_distance) < 6.0, "diagonal normalizada")
    await _release_inputs()
    # A mesa tem footprint no intervalo x 815..1040, y 188..310.
    game.player.global_position = Vector2(790, 250)
    game.player.velocity = Vector2.ZERO
    Input.action_press("move_right")
    for _i in range(35):
        await physics_frame
    Input.action_release("move_right")
    _expect(game.player.global_position.x < 801.0, "a princesa não atravessa a escrivaninha")
    await _release_inputs()
    game.player.global_position = Vector2(60, 400)
    game.player.velocity = Vector2.ZERO
    Input.action_press("move_left")
    for _i in range(30):
        await physics_frame
    Input.action_release("move_left")
    _expect(game.player.global_position.x >= 49.0, "limite esquerdo bloqueia a princesa")
    await _release_inputs()

func _release_inputs() -> void:
    for action in ["move_left", "move_right", "move_up", "move_down", "interact"]:
        Input.action_release(action)
    await process_frame

func _expect(condition: bool, label: String) -> void:
    if not condition:
        failures.append(label)
