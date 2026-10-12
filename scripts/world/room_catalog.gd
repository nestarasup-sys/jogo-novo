extends RefCounted
## Registro de cenas: adicionar uma área exige só um arquivo .tscn e uma entrada JSON.

const CATALOG_PATH = "res://data/room_catalog.json"
var room_paths: Dictionary = {}
var start_room: String = ""
var start_spawn: String = ""

func load_catalog() -> bool:
    if not FileAccess.file_exists(CATALOG_PATH):
        push_error("Catálogo ausente: " + CATALOG_PATH)
        return false
    var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
    if file == null:
        push_error("Não foi possível abrir o catálogo.")
        return false
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if not (parsed is Dictionary):
        push_error("Catálogo de ambientes precisa ser um objeto JSON.")
        return false
    if int(parsed.get("schema_version", -1)) != 1:
        push_error("Versão de catálogo não suportada.")
        return false
    var entries: Variant = parsed.get("rooms", null)
    if not (entries is Dictionary) or entries.is_empty():
        push_error("Catálogo sem ambientes.")
        return false
    room_paths = entries
    start_room = str(parsed.get("start_room", ""))
    start_spawn = str(parsed.get("start_spawn", ""))
    if not room_paths.has(start_room) or start_spawn.is_empty():
        push_error("Entrada inicial do catálogo inválida.")
        return false
    for room_id in room_paths.keys():
        var path: String = str(room_paths[room_id])
        if not path.begins_with("res://scenes/rooms/") or not ResourceLoader.exists(path, "PackedScene"):
            push_error("Cena inválida no catálogo: " + str(room_id) + " → " + path)
            return false
    return true

func get_scene(room_id: String) -> PackedScene:
    if not room_paths.has(room_id):
        push_error("Ambiente não registrado: " + room_id)
        return null
    return load(str(room_paths[room_id])) as PackedScene
