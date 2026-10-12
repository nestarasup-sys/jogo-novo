extends Node2D
## GameRoot mínimo: somente quarto, corredor e jardim.

const MAP_SCENES := {
    "bedroom": preload("res://scenes/maps/bedroom.tscn"),
    "corridor": preload("res://scenes/maps/corridor.tscn"),
    "garden": preload("res://scenes/maps/garden.tscn")
}
var current_map
var player
var hud
var controls
var current_map_id: String = "bedroom"

func _ready() -> void:
    _setup_input()
    player = preload("res://scripts/player.gd").new()
    player.name = "PrincessPlaceholder"
    add_child(player)
    hud = preload("res://scripts/prototype_hud.gd").new()
    add_child(hud)
    controls = preload("res://scripts/mobile_controls.gd").new()
    add_child(controls)
    _enter_map("bedroom", Vector2(640, 420))

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
        InputMap.action_add_event(action, event)

func _enter_map(map_id: String, spawn: Vector2) -> void:
    if not MAP_SCENES.has(map_id):
        push_error("Map not found: " + map_id)
        return
    if is_instance_valid(current_map):
        remove_child(current_map)
        current_map.queue_free()
    current_map = MAP_SCENES[map_id].instantiate()
    current_map_id = map_id
    add_child(current_map)
    move_child(current_map, 0)
    player.global_position = spawn
    player.velocity = Vector2.ZERO
    hud.set_location({"bedroom": "Quarto da princesa", "corridor": "Corredor do palácio", "garden": "Jardim"}[map_id])
    hud.set_prompt("")

func _process(_delta: float) -> void:
    if hud.is_message_open():
        player.movement_enabled = false
        if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("close_message"):
            hud.close_message()
        return
    player.movement_enabled = true
    var near: Dictionary = current_map.nearest_interaction(player.global_position)
    hud.set_prompt("E / AÇÃO — " + str(near["label"]) if not near.is_empty() else "")
    if Input.is_action_just_pressed("interact") and not near.is_empty():
        _activate(near)

func _activate(item: Dictionary) -> void:
    match item["kind"]:
        "door":
            _enter_map(item["target"], item["spawn"])
        "message":
            hud.show_message(item["label"], item["text"])
        _:
            push_warning("Unknown interaction type: " + str(item["kind"]))
