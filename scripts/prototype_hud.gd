extends CanvasLayer
## Nós de HUD persistentes/visíveis no editor — sem construção de interface em _ready().

@onready var title_label: Label = $HudRoot/Location
@onready var prompt_label: Label = $HudRoot/Prompt
@onready var overlay: Control = $HudRoot/MessageOverlay
@onready var message_title: Label = $HudRoot/MessageOverlay/MessageBox/MessageTitle
@onready var message_label: Label = $HudRoot/MessageOverlay/MessageBox/MessageText

var _open: bool = false
var prompt_text: String = ""

func _ready() -> void:
    layer = 1
    overlay.visible = false

func set_location(label: String) -> void:
    title_label.text = label

func set_prompt(label: String) -> void:
    if label == prompt_text:
        return
    prompt_text = label
    prompt_label.text = label

func is_message_open() -> bool:
    return _open

func show_message(title: String, text: String) -> void:
    _open = true
    message_title.text = title
    message_label.text = text
    overlay.visible = true
    set_prompt("")

func close_message() -> void:
    _open = false
    overlay.visible = false
