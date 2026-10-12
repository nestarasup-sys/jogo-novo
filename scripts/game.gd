extends Node2D
## Coordenação de jogo: não contém decoração, colisão nem lógica de objeto.

const ROOM_CATALOG := preload("res://scripts/world/room_catalog.gd")
const PLAYER_SCRIPT := preload("res://scripts/player.gd")
const CAMERA_SCRIPT := preload("res://scripts/world/world_camera.gd")
const HUD_SCRIPT := preload("res://scripts/prototype_hud.gd")

@export_range(0.75, 2.0, 0.05) var world_zoom: float = 1.30

var catalog
var player: CharacterBody2D
var camera: Camera2D
var hud: CanvasLayer
var current_room: Node2D
var current_map_id: String = ""
var _room_changing: bool = false

func _ready() -> void:
    _setup_input()
    catalog = ROOM_CATALOG.new()
    if not catalog.load_catalog():
        push_error("Não foi possível iniciar: catálogo inválido.")
        return
    player = PLAYER_SCRIPT.new() as CharacterBody2D
    player.name = "Princess"
    add_child(player)
    camera = CAMERA_SCRIPT.new() as Camera2D
    camera.name = "WorldCamera"
    camera.world_zoom = world_zoom
    player.add_child(camera)
    hud = HUD_SCRIPT.new() as CanvasLayer
    add_child(hud)
    _enter_room(catalog.start_room, catalog.start_spawn)

func _setup_input() -> void:
    _add_keys("move_left", [KEY_A, KEY_LEFT])
    _add_keys("move_right", [KEY_D, KEY_RIGHT])
    _add_keys("move_up", [KEY_W, KEY_UP])
    _add_keys("move_down", [KEY_S, KEY_DOWN])
    _add_keys("interact", [KEY_E, KEY_SPACE, KEY_ENTER])
    _add_keys("close_message", [KEY_ESCAPE])

func _add_keys(action: String, keys: Array) -> void:
    if not InputMap.has_action(action):
        InputMap.add_action(action)
    for key in keys:
        var event := InputEventKey.new()
        event.physical_keycode = key
        if not InputMap.action_has_event(action, event):
            InputMap.action_add_event(action, event)

func _enter_room(room_id: String, spawn_id: String) -> bool:
    if _room_changing:
        return false
    _room_changing = true
    var scene: PackedScene = catalog.get_scene(room_id)
    if scene == null:
        _room_changing = false
        return false
    var room: Node2D = scene.instantiate() as Node2D
    if room == null or str(room.get("room_id")) != room_id:
        push_error("room_id inconsistente: " + room_id)
        if room != null:
            room.free()
        _room_changing = false
        return false
    var spawn: Vector2 = room.get_spawn(spawn_id)
    var bounds: Vector2 = room.get("room_size")
    if spawn.x < 50.0 or spawn.y < 50.0 or spawn.x > bounds.x - 50.0 or spawn.y > bounds.y - 50.0:
        push_error("Spawn inválido: " + room_id + "/" + spawn_id)
        room.free()
        _room_changing = false
        return false
    # Só descarregar o ambiente anterior depois que o novo tiver sido validado.
    if is_instance_valid(current_room):
        remove_child(current_room)
        current_room.queue_free()
    current_room = room
    current_map_id = room_id
    add_child(current_room)
    move_child(current_room, 0)
    player.global_position = spawn
    player.velocity = Vector2.ZERO
    camera.set_room_size(bounds)
    hud.set_location(str(room.get("room_title")))
    hud.set_prompt("")
    _room_changing = false
    return true

func _process(_delta: float) -> void:
    if not is_instance_valid(player) or not is_instance_valid(current_room):
        return
    if hud.is_message_open():
        player.movement_enabled = false
        if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("close_message"):
            hud.close_message()
        return
    player.movement_enabled = true
    var nearby: Dictionary = current_room.nearest_interaction(player.global_position)
    hud.set_prompt("E — " + str(nearby.get("label", "")) if not nearby.is_empty() else "")
    if Input.is_action_just_pressed("interact") and not nearby.is_empty():
        _activate_interaction(nearby)

func _activate_interaction(action: Dictionary) -> void:
    match str(action.get("kind", "")):
        "door":
            _enter_room(str(action.get("target", "")), str(action.get("spawn_id", "")))
        "inspect":
            hud.show_message(str(action.get("label", "")), str(action.get("message", "")))
        _:
            push_warning("Tipo de interação desconhecido: " + str(action.get("kind", "")))
