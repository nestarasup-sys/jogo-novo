extends Node2D
## Editor-first: princesa, câmera, HUD e quarto inicial são cenas salvas.
## Runtime reutiliza essas instâncias e troca só os ambientes quando necessário.

const ROOM_CATALOG = preload("res://scripts/world/room_catalog.gd")

@export_range(0.75, 2.0, 0.05) var world_zoom: float = 1.30

@onready var room_container: Node2D = $RoomContainer
@onready var player = $Princess
@onready var camera = $Princess/WorldCamera
@onready var hud = $HUD

var catalog
var current_room
var current_map_id: String = ""
var _room_changing: bool = false

func _ready() -> void:
    _setup_input()
    catalog = ROOM_CATALOG.new()
    if not catalog.load_catalog():
        push_error("Catálogo inválido.")
        return
    camera.world_zoom = world_zoom
    var preview_room: Node2D = room_container.get_child(0) as Node2D if room_container.get_child_count() > 0 else null
    if preview_room != null and str(preview_room.get("room_id")) == catalog.start_room:
        current_room = preview_room
        _adopt_room(preview_room, catalog.start_room, catalog.start_spawn)
    else:
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
    var room = scene.instantiate()
    if room == null or str(room.get("room_id")) != room_id:
        push_error("room_id inconsistente: " + room_id)
        if room != null:
            room.free()
        _room_changing = false
        return false
    var spawn: Vector2 = room.get_spawn(spawn_id)
    var bounds: Vector2 = room.get("room_size")
    if not _valid_spawn(spawn, bounds):
        push_error("Spawn inválido: " + room_id + "/" + spawn_id)
        room.free()
        _room_changing = false
        return false
    var previous_room = current_room
    room_container.add_child(room)
    current_room = room
    current_map_id = room_id
    player.reparent(room.get_node("WorldSpace"))
    player.global_position = spawn
    if is_instance_valid(previous_room):
        previous_room.queue_free()
    player.velocity = Vector2.ZERO
    camera.set_room_size(bounds)
    hud.set_location(str(room.get("room_title")))
    hud.set_prompt("")
    _room_changing = false
    return true

func _adopt_room(room, room_id: String, spawn_id: String) -> void:
    var spawn: Vector2 = room.get_spawn(spawn_id)
    var bounds: Vector2 = room.get("room_size")
    if not _valid_spawn(spawn, bounds):
        push_error("Spawn inicial inválido: " + room_id + "/" + spawn_id)
        return
    current_map_id = room_id
    player.reparent(room.get_node("WorldSpace"))
    player.global_position = spawn
    player.velocity = Vector2.ZERO
    camera.set_room_size(bounds)
    hud.set_location(str(room.get("room_title")))
    hud.set_prompt("")

func _valid_spawn(spawn: Vector2, bounds: Vector2) -> bool:
    return spawn.x >= 50.0 and spawn.y >= 50.0 and spawn.x <= bounds.x - 50.0 and spawn.y <= bounds.y - 50.0

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
