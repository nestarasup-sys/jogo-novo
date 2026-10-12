extends SceneTree
## Teste smoke da arquitetura modular — Godot 4.7.2 / Windows.
## godot --headless --path . --script res://tests/smoke.gd

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const CATALOG_SCRIPT := preload("res://scripts/world/room_catalog.gd")

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
    var invalid: bool = game._enter_room("nonexistent_room", "start")
    _expect(not invalid and game.current_map_id == "bedroom", "falha de destino não destrói mapa atual")
    game.queue_free()
    await process_frame

func _expect(condition: bool, label: String) -> void:
    if not condition:
        failures.append(label)
