extends SceneTree
## Teste smoke da arquitetura modular — Godot 4.7.2 / Windows.
## godot --headless --path . --script res://tests/smoke.gd

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const CATALOG_SCRIPT = preload("res://scripts/world/room_catalog.gd")
const USEFUL_FURNITURE: Array[String] = [
    "Bed", "Vanity", "Wardrobe", "WritingDesk", "Bookshelf", "Armchair", "Chest"
]
const DECOR_FURNITURE: Array[String] = [
    "Rug", "DoorVisual", "SideTable", "Mirror", "Plant", "WallDecoration"
]
const FURNITURE_TEXTURES: Dictionary = {
    "Bed": "bedroom_bed.png",
    "Vanity": "vanity.png",
    "Wardrobe": "wardrobe.png",
    "WritingDesk": "writing_desk.png",
    "Bookshelf": "bookshelf.png",
    "Armchair": "armchair.png",
    "Chest": "chest.png"
}
const DECOR_TEXTURES: Dictionary = {
    "Rug": "rug.png",
    "DoorVisual": "door_visual.png",
    "SideTable": "side_table.png",
    "Mirror": "mirror.png",
    "Plant": "plant.png",
    "WallDecoration": "wall_art.png"
}

var failures: Array[String] = []

func _initialize() -> void:
    call_deferred("_run")

func _run() -> void:
    root.size = Vector2i(1280, 720)
    _test_editor_authoring()
    _test_catalog_and_rooms()
    await _test_gameplay()
    if failures.is_empty():
        print("PASS: móveis, decoração, menus, cama, princesa, colisões, interações e portas")
        quit(0)
    else:
        for failure in failures:
            push_error("FAIL: " + failure)
        quit(1)

func _test_editor_authoring() -> void:
    # Antes de _ready, a cena já deve conter tudo que precisa aparecer no editor.
    var preview = MAIN_SCENE.instantiate()
    _expect(preview.get_node_or_null("RoomContainer/Bedroom") != null, "main mostra quarto instanciado")
    _expect(preview.get_node_or_null("Princess") != null, "main mostra protagonista instanciada")
    _expect(preview.get_node_or_null("Princess/WorldCamera") != null, "main contém câmera editável")
    var sprite := preview.get_node_or_null("Princess/PrincessAnimatedSprite") as AnimatedSprite2D
    _expect(sprite != null and sprite.sprite_frames != null, "spriteframes persistidos no editor")
    if sprite != null and sprite.sprite_frames != null:
        _expect(sprite.sprite_frames.has_animation("walk"), "animação WALK visível no editor")
        _expect(sprite.sprite_frames.get_frame_count("walk") == 4, "walk possui quatro quadros persistidos")
    _expect(preview.get_node_or_null("Princess/FootCollisionShape") != null, "colisor dos pés editável")
    _expect(preview.get_node_or_null("HUD/HudRoot/Location") != null, "HUD editável como cena")
    _expect(preview.get_node_or_null("HUD/HudRoot/MessageOverlay/MessageBox") != null, "painel de diálogo editável")
    var bed = preview.get_node_or_null("RoomContainer/Bedroom/WorldSpace/Furniture/Bed")
    _expect(bed != null and bed.art_texture != null
        and bed.art_texture.resource_path == "res://assets/furniture/bedroom_bed.png",
        "cama usa arte do sheet do criador")
    var furniture_root: Node = preview.get_node("RoomContainer/Bedroom/WorldSpace/Furniture")
    for item_name in USEFUL_FURNITURE + DECOR_FURNITURE:
        var item: Node = furniture_root.get_node_or_null(item_name)
        _expect(item != null, "móvel editável existe: " + item_name)
        if item == null:
            continue
        _expect(item.get_script() != null and item.get_script().resource_path == "res://scripts/world/furniture.gd",
            "componente furniture atribuído: " + item_name)
        _expect(item.get("art_size") is Vector2 and item.get("art_offset") is Vector2
            and item.get("footprint_size") is Vector2,
            "arte e footprint ajustáveis no Inspector: " + item_name)
        var item_texture: Texture2D = item.get("art_texture") as Texture2D
        var expected_texture: String = str(FURNITURE_TEXTURES[item_name]) if USEFUL_FURNITURE.has(item_name) else str(DECOR_TEXTURES[item_name])
        _expect(item_texture != null and item_texture.resource_path
            == "res://assets/furniture/" + expected_texture,
            "arte correta atribuída: " + item_name)
        if item_texture != null:
            var texture_image: Image = item_texture.get_image()
            _expect(texture_image != null and texture_image.get_pixel(0, 0).a == 0.0,
                "PNG tem transparência: " + item_name)
        var visual: Node2D = item.get_node_or_null("Visual") as Node2D
        _expect(visual != null and visual.get_script() != null
            and visual.get_script().resource_path == "res://scripts/world/furniture_visual.gd",
            "camada visual separada para edição pelo mouse: " + item_name)
        if visual != null:
            _expect(visual.get("art_texture") == item.get("art_texture")
                and visual.get("art_size") == item.get("art_size")
                and visual.get("art_offset") == item.get("art_offset"),
                "arte exposta no Inspector do filho Visual: " + item_name)
        _expect(item.get_node_or_null("Footprint") != null,
            "footprint persistido na cena: " + item_name)
    for item_name in DECOR_FURNITURE:
        var decor: Node = furniture_root.get_node_or_null(item_name)
        if decor != null:
            _expect(not decor.get("is_solid"), "decoração sem colisão: " + item_name)
            _expect((decor.get_node("Visual") as CanvasItem).visible,
                "arte da decoração aparece: " + item_name)
    var bed_use = preview.get_node_or_null("RoomContainer/Bedroom/Interactions/BedUse")
    _expect(bed_use != null and bed_use.interaction_type == "bed" and bed_use.action_label == "Usar cama",
        "cama tem interação de uso própria")
    _expect(preview.get_node_or_null("RoomContainer/Bedroom/Spawns/BedSitPosition") != null,
        "ponto de sentar configurado na cena")
    _expect(preview.get_node_or_null("HUD/BedActionMenu/Card/ActionPanel/SitButton") != null,
        "menu de ações da cama presente")
    _expect(preview.get_node_or_null("HUD/BedActionMenu/Card/HoursPanel/Hour8") != null,
        "menu de duração do sono presente")
    _expect(preview.get_node_or_null("HUD/InteractionChoiceMenu/Card/Content/CancelButton") != null,
        "menu reutilizável de móveis presente")
    _expect(preview.get_node_or_null("HUD/HudRoot/MessageOverlay/MessageBox/CloseButton") != null,
        "mensagens têm botão de fechar")
    var bed_art: Node2D = bed.get_node("Visual") as Node2D
    var bed_footprint: CollisionShape2D = bed.get_node("Footprint") as CollisionShape2D
    var original_bed_position: Vector2 = bed.global_position
    var original_footprint_position: Vector2 = bed_footprint.global_position
    bed_art.position = Vector2(18.0, -12.0)
    _expect(bed.global_position == original_bed_position
        and bed_footprint.global_position == original_footprint_position,
        "arrastar Visual muda apenas a arte, sem deslocar cama ou colisão")
    bed_art.position = Vector2.ZERO
    var original_art_offset: Vector2 = bed.art_offset
    bed_art.set("art_offset", original_art_offset + Vector2(3.0, -2.0))
    _expect(bed.art_offset == original_art_offset + Vector2(3.0, -2.0),
        "editar art_offset no Inspector de Visual altera a arte do móvel")
    bed_art.set("art_offset", original_art_offset)
    preview.free()

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
        _expect(room.get_node_or_null("Boundaries") != null, "colisões persistidas na cena: " + room_id)
        if room.get_node_or_null("Boundaries") != null:
            _expect(room.get_node("Boundaries").get_child_count() == 4, "quatro bordas selecionáveis: " + room_id)
        _expect(room.get_node_or_null("WorldSpace/Furniture") != null, "móveis independentes: " + room_id)
        _expect(room.get_node_or_null("Interactions") != null, "interações independentes: " + room_id)
        _expect(room.get_node_or_null("Spawns") != null, "spawns independentes: " + room_id)
        _expect(room.get_node("Visual").get_script().is_tool(), "piso e parede desenhados no editor: " + room_id)
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
                _expect(furniture.get_script().is_tool(), "móvel desenhado no editor: " + furniture.name)
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
        _expect(absf(sprite.scale.y - (180.0 / 505.0)) < 0.002,
            "protagonista aumentada em 20% sem alterar hitbox")
    var circle: CollisionShape2D = game.player.get_node_or_null("FootCollisionShape") as CollisionShape2D
    _expect(circle != null and circle.shape is CircleShape2D, "colisão da princesa preservada")
    var cam: Camera2D = game.player.get_node_or_null("WorldCamera") as Camera2D
    _expect(cam != null, "câmera modular")
    if cam != null:
        _expect(is_equal_approx(cam.zoom.x, 1.30) and is_equal_approx(cam.zoom.y, 1.30), "zoom uniforme 130%")
        _expect(cam.limit_right == 1280 and cam.limit_bottom == 720, "limites de câmera")
    _expect(game.current_room.get_node("WorldSpace/Furniture").get_child_count() == 13,
        "sete móveis úteis e seis itens decorativos instanciados")
    # Quarto inicial legível com câmera 1.30: móveis não cortados lateralmente.
    # A colisão norte é intencionalmente excluída desta verificação porque
    # o criador a ajustou localmente e ela precisa ser preservada.
    var visible_left: float = 640.0 - 1280.0 / (2.0 * 1.30)
    var visible_right: float = 640.0 + 1280.0 / (2.0 * 1.30)
    for item in game.current_room.get_node("WorldSpace/Furniture").get_children():
        var half_width: float = item.footprint_size.x * 0.5
        _expect(item.position.x - half_width > visible_left + 5.0,
            "móvel sem corte na esquerda: " + item.name)
        _expect(item.position.x + half_width < visible_right - 5.0,
            "móvel sem corte na direita: " + item.name)
    var bed_node = game.current_room.get_node("WorldSpace/Furniture/Bed")
    var desk_node = game.current_room.get_node("WorldSpace/Furniture/WritingDesk")
    var wardrobe_node = game.current_room.get_node("WorldSpace/Furniture/Wardrobe")
    var armchair_node = game.current_room.get_node("WorldSpace/Furniture/Armchair")
    var vanity_node = game.current_room.get_node("WorldSpace/Furniture/Vanity")
    var bookshelf_node = game.current_room.get_node("WorldSpace/Furniture/Bookshelf")
    var chest_node = game.current_room.get_node("WorldSpace/Furniture/Chest")
    var mirror_node = game.current_room.get_node("WorldSpace/Furniture/Mirror")
    var side_table_node = game.current_room.get_node("WorldSpace/Furniture/SideTable")
    var wall_art_node = game.current_room.get_node("WorldSpace/Furniture/WallDecoration")
    _expect(wall_art_node.art_size.y < 0.70 * 180.0,
        "quadro de parede menor que a princesa em escala de referência")
    _expect(game.current_room.get_node("WorldSpace/Furniture/SideTable").art_size.y >= 130.0,
        "mesa lateral continua fácil de ver")
    _expect(game.current_room.get_node("WorldSpace/Furniture/Mirror").art_size.y >= 145.0,
        "espelho tem tamanho funcional em relação à personagem")
    _expect(game.current_room.get_node("WorldSpace/Furniture/Plant").art_size.y >= 115.0,
        "planta decorativa não fica pequena demais")
    for item in game.current_room.get_node("WorldSpace/Furniture").get_children():
        _expect(item.art_size.y <= 210.0,
            "altura dos móveis proporcional à personagem: " + item.name)
    _expect(bed_node.position.x == 300.0 and bed_node.position.y == 355.0
        and armchair_node.position.x == 310.0 and armchair_node.position.y == 575.0,
        "zona de descanso agrupada no lado esquerdo")
    _expect(vanity_node.position.x == 820.0 and desk_node.position.x == 820.0
        and wardrobe_node.position.x == 1045.0 and bookshelf_node.position.x == 1070.0
        and chest_node.position.x == 1050.0,
        "zona de penteadeira, trabalho e armazenamento agrupada à direita")
    _expect(side_table_node.position.distance_to(bed_node.position) < 180.0,
        "mesa lateral posicionada ao lado da cama")
    _expect(mirror_node.position.x > vanity_node.position.x
        and mirror_node.position.distance_to(vanity_node.position) < 240.0,
        "espelho integrado à zona de arrumação sem sobrepor a penteadeira")
    _expect(bed_node.position.x < 450.0 and armchair_node.position.x < 450.0
        and desk_node.position.x > 760.0 and wardrobe_node.position.x > 1000.0
        and bookshelf_node.position.x > 900.0 and chest_node.position.x > 950.0,
        "móveis agrupados nas laterais com circulação central aberta")
    for item_name in DECOR_FURNITURE:
        var decor: Node = game.current_room.get_node("WorldSpace/Furniture/" + item_name)
        var decor_footprint: CollisionShape2D = decor.get_node("Footprint")
        _expect(not decor.is_solid and decor_footprint.disabled,
            "decoração atravessável sem colisão ativa: " + item_name)
    _expect(bed_node.position.y - bed_node.footprint_size.y * 0.5 > 215.0,
        "cama longe do HUD superior")
    _expect(desk_node.position.y - desk_node.footprint_size.y * 0.5 > 215.0,
        "escrivaninha longe do HUD superior")
    _expect(game.current_room.get_node("WorldSpace/Furniture/Rug").position.distance_to(Vector2(455, 555)) < 1.0,
        "tapete define uma área central de descanso sem bloquear passagem")
    _expect(game.hud.get_node_or_null("HudRoot/TopPlate") != null,
        "HUD tem painel compacto")
    game.hud.set_prompt("Teste")
    _expect(game.hud.get_node("HudRoot/PromptPlate").visible,
        "painel de interação aparece com dica")
    game.hud.set_prompt("")
    _expect(not game.hud.get_node("HudRoot/PromptPlate").visible,
        "painel de interação some sem dica")

    await _test_player_movement(game)
    game.player.global_position = game.current_room.get_node("Interactions/BedUse").global_position
    var bed: Dictionary = game.current_room.nearest_interaction(game.player.global_position)
    _expect(bed.get("kind") == "bed" and bed.get("label") == "Usar cama", "cama oferece ação própria por proximidade")
    game._activate_interaction(bed)
    _expect(game.hud.is_bed_menu_open(), "interação abre menu da cama")
    var bed_menu: Control = game.hud.get_node("BedActionMenu")
    var actions_panel: Control = bed_menu.get_node("Card/ActionPanel")
    var hours_panel: Control = bed_menu.get_node("Card/HoursPanel")
    var old_hour: int = game.current_hour
    (actions_panel.get_node("SleepButton") as Button).pressed.emit()
    _expect(hours_panel.visible and not actions_panel.visible, "Dormir abre escolha de horas")
    (hours_panel.get_node("CancelButton") as Button).pressed.emit()
    _expect(actions_panel.visible and game.current_hour == old_hour, "cancelar horas retorna ao menu sem avançar tempo")
    (actions_panel.get_node("CancelButton") as Button).pressed.emit()
    _expect(not game.hud.is_bed_menu_open(), "Cancelar fecha menu da cama")

    game._activate_interaction(bed)
    (actions_panel.get_node("SitButton") as Button).pressed.emit()
    _expect(game.player.global_position.distance_to(Vector2(420, 425)) < 0.5, "Sentar posiciona a princesa junto à cama")
    _expect(game.hud.is_message_open(), "Sentar confirma ação em mensagem")
    _expect(not game.player.movement_enabled, "mensagem de sentar bloqueia movimento")
    (game.hud.get_node("HudRoot/MessageOverlay/MessageBox/CloseButton") as Button).pressed.emit()
    _expect(not game.hud.is_message_open(), "botão Fechar encerra mensagem")

    game._activate_interaction(bed)
    (actions_panel.get_node("SleepButton") as Button).pressed.emit()
    (hours_panel.get_node("Hour4") as Button).pressed.emit()
    _expect(game.current_hour == (old_hour + 4) % 24, "Dormir avança o relógio do protótipo")
    _expect(game.hud.is_message_open() and game.hud.message_label.text.contains("4 horas"),
        "Dormir mostra duração escolhida")
    _expect(game.hud.message_label.text.contains("12:00"), "resultado informa a hora após dormir")
    game.hud.close_message()
    _expect(not game.hud.is_message_open(), "mensagem fecha")

    var object_interactions := {
        "VanityUse": ["vanity", "examine", "Vanity"],
        "WardrobeUse": ["wardrobe", "change_clothes", "Wardrobe"],
        "WritingDeskUse": ["writing_desk", "read_letters", "WritingDesk"],
        "BookshelfUse": ["bookshelf", "read_book", "Bookshelf"],
        "ArmchairUse": ["armchair", "sit", "Armchair"],
        "ChestUse": ["chest", "open", "Chest"]
    }
    var choice_menu: Control = game.hud.get_node("InteractionChoiceMenu")
    var choice_buttons: VBoxContainer = choice_menu.get_node("Card/Content/Options")
    for marker_name in object_interactions:
        var interaction: Marker2D = game.current_room.get_node("Interactions/" + marker_name)
        var owner: Node2D = game.current_room.get_node(
            "WorldSpace/Furniture/" + object_interactions[marker_name][2])
        _expect(owner.global_position.distance_to(interaction.global_position)
            <= interaction.interaction_radius,
            "marcador de uso ao alcance de " + owner.name)
        game.player.global_position = interaction.global_position
        var furniture_action: Dictionary = game.current_room.nearest_interaction(game.player.global_position)
        _expect(furniture_action.get("kind") == "menu"
            and furniture_action.get("menu_id") == object_interactions[marker_name][0],
            "interação próxima roteia o menu correto: " + marker_name)
        game._activate_interaction(furniture_action)
        _expect(game.hud.is_choice_menu_open(), "menu de ações abre: " + marker_name)
        _expect(choice_menu.get_node("Card/Content/Title").text != "",
            "menu apresenta título: " + marker_name)
        _expect(choice_buttons.get_child_count() == 2,
            "menu apresenta duas opções e Cancelar: " + marker_name)
        var option_id: String = object_interactions[marker_name][1]
        var option_button: Button = choice_buttons.get_node("Option_" + option_id)
        option_button.pressed.emit()
        _expect(not game.hud.is_choice_menu_open() and game.hud.is_message_open(),
            "ação placeholder fecha menu e mostra retorno: " + marker_name)
        _expect(not game.hud.message_label.text.is_empty(),
            "ação placeholder apresenta mensagem: " + marker_name)
        game.hud.close_message()
    var wardrobe_interaction: Marker2D = game.current_room.get_node("Interactions/WardrobeUse")
    game.player.global_position = wardrobe_interaction.global_position
    game._activate_interaction(game.current_room.nearest_interaction(game.player.global_position))
    (choice_menu.get_node("Card/Content/CancelButton") as Button).pressed.emit()
    _expect(not game.hud.is_choice_menu_open(), "Cancelar fecha menu reutilizável")

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
    # A escrivaninha ocupa x 745..895, y 499..621, com personagem à esquerda.
    game.player.global_position = Vector2(650, 560)
    game.player.velocity = Vector2.ZERO
    Input.action_press("move_right")
    for _i in range(35):
        await physics_frame
    Input.action_release("move_right")
    _expect(game.player.global_position.x < 730.0, "a princesa não atravessa a escrivaninha")
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
