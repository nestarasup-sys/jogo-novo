extends Node2D
## Editor-first: princesa, câmera, HUD e quarto inicial são cenas salvas.
## Runtime reutiliza essas instâncias e troca só os ambientes quando necessário.

const ROOM_CATALOG = preload("res://scripts/world/room_catalog.gd")

const FURNITURE_MENUS: Dictionary = {
	"vanity": {"title": "Penteadeira", "options": [
		{"id": "examine", "label": "Examinar"},
		{"id": "appearance", "label": "Arrumar aparência"}
	]},
	"wardrobe": {"title": "Guarda-roupa", "options": [
		{"id": "change_clothes", "label": "Trocar roupa"},
		{"id": "organize", "label": "Organizar"}
	]},
	"writing_desk": {"title": "Escrivaninha", "options": [
		{"id": "read_letters", "label": "Ler cartas"},
		{"id": "write", "label": "Escrever"}
	]},
	"bookshelf": {"title": "Estante", "options": [
		{"id": "read_book", "label": "Ler livro"},
		{"id": "examine", "label": "Examinar"}
	]},
	"armchair": {"title": "Poltrona", "options": [
		{"id": "sit", "label": "Sentar"},
		{"id": "rest", "label": "Descansar"}
	]},
	"chest": {"title": "Baú", "options": [
		{"id": "open", "label": "Abrir"},
		{"id": "store_item", "label": "Guardar item"}
	]}
}

const FURNITURE_MESSAGES: Dictionary = {
	"vanity/examine": "Uma penteadeira provisória para testar a interação.",
	"vanity/appearance": "Arrumar aparência ainda é uma opção placeholder.",
	"wardrobe/change_clothes": "Trocar roupa ainda é uma opção placeholder.",
	"wardrobe/organize": "Organizar o guarda-roupa ainda é uma opção placeholder.",
	"writing_desk/read_letters": "Ler cartas ainda é uma opção placeholder.",
	"writing_desk/write": "Escrever ainda é uma opção placeholder.",
	"bookshelf/read_book": "Ler um livro ainda é uma opção placeholder.",
	"bookshelf/examine": "Uma estante provisória para testar a interação.",
	"armchair/sit": "Sentar na poltrona ainda é uma opção placeholder.",
	"armchair/rest": "Descansar na poltrona ainda é uma opção placeholder.",
	"chest/open": "Abrir o baú ainda é uma opção placeholder.",
	"chest/store_item": "Guardar item ainda é uma opção placeholder."
}

@export_range(0.75, 2.0, 0.05) var world_zoom: float = 1.30

@onready var room_container: Node2D = $RoomContainer
@onready var player = $Princess
@onready var camera = $Princess/WorldCamera
@onready var hud = $HUD

var catalog
var current_room
var current_map_id: String = ""
var current_hour: int = 8
var _room_changing: bool = false

func _ready() -> void:
    _setup_input()
    hud.connect("bed_sit_selected", _on_bed_sit_selected)
    hud.connect("bed_sleep_hours_selected", _on_bed_sleep_hours_selected)
	hud.connect("interaction_choice_selected", _on_interaction_choice_selected)
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
    if hud.is_bed_menu_open():
        player.movement_enabled = false
        if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("close_message"):
            hud.close_bed_menu()
        return
	if hud.is_choice_menu_open():
		player.movement_enabled = false
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("close_message"):
			hud.close_choice_menu()
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
        "bed":
            hud.open_bed_menu()
		"menu":
			_open_furniture_menu(str(action.get("menu_id", "")))
        "inspect":
            hud.show_message(str(action.get("label", "")), str(action.get("message", "")))
        _:
            push_warning("Tipo de interação desconhecido: " + str(action.get("kind", "")))

func _open_furniture_menu(menu_id: String) -> void:
	var menu: Dictionary = FURNITURE_MENUS.get(menu_id, {})
	if menu.is_empty():
		push_warning("Menu de móvel desconhecido: " + menu_id)
		return
	hud.open_choice_menu(menu_id, str(menu.get("title", "Interagir")), menu.get("options", []))

func _on_interaction_choice_selected(menu_id: String, option_id: String) -> void:
	var message_id: String = menu_id + "/" + option_id
	var message: String = str(FURNITURE_MESSAGES.get(message_id, "Esta ação ainda é um placeholder."))
	var menu: Dictionary = FURNITURE_MENUS.get(menu_id, {})
	hud.show_message(str(menu.get("title", "Interação")), message)

func advance_hours(hours: int) -> int:
    if hours > 0:
        current_hour = (current_hour + hours) % 24
    return current_hour

func _on_bed_sit_selected() -> void:
    player.movement_enabled = false
    var sit_marker: Marker2D = current_room.get_node_or_null("Spawns/BedSitPosition") as Marker2D
    if sit_marker == null:
        push_error("Ponto de sentar da cama não encontrado.")
        return
    player.global_position = sit_marker.global_position
    player.velocity = Vector2.ZERO
    hud.show_message("Sentar", "A princesa se sentou à beira da cama. Pressione E, Esc ou Fechar para se levantar.")

func _on_bed_sleep_hours_selected(hours: int) -> void:
    if hours <= 0 or hours > 24:
        push_error("Quantidade de horas inválida: %d" % hours)
        return
    player.movement_enabled = false
    var new_hour: int = advance_hours(hours)
    hud.show_message("Descanso", "A princesa dormiu %d horas. Agora são %02d:00." % [hours, new_hour])
