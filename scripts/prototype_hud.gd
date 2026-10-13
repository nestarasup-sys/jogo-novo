extends CanvasLayer
## Nós de HUD persistentes/visíveis no editor — sem construção de interface em _ready().

signal bed_sit_selected
signal bed_sleep_hours_selected(hours: int)

@onready var title_label: Label = $HudRoot/Location
@onready var prompt_label: Label = $HudRoot/Prompt
@onready var prompt_plate: Panel = $HudRoot/PromptPlate
@onready var overlay: Control = $HudRoot/MessageOverlay
@onready var message_title: Label = $HudRoot/MessageOverlay/MessageBox/MessageTitle
@onready var message_label: Label = $HudRoot/MessageOverlay/MessageBox/MessageText
@onready var close_button: Button = $HudRoot/MessageOverlay/MessageBox/CloseButton
@onready var bed_menu: Control = $BedActionMenu

var _open: bool = false
var prompt_text: String = ""

func _ready() -> void:
    layer = 1
    overlay.visible = false
    prompt_plate.visible = false
    close_button.pressed.connect(close_message)
    bed_menu.connect("sit_selected", _on_bed_sit_selected)
    bed_menu.connect("sleep_hours_selected", _on_bed_sleep_hours_selected)

func set_location(label: String) -> void:
    title_label.text = label

func set_prompt(label: String) -> void:
    if label == prompt_text:
        return
    prompt_text = label
    prompt_label.text = label
    prompt_plate.visible = not label.is_empty()

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

func open_bed_menu() -> void:
    set_prompt("")
    bed_menu.call("open_menu")

func is_bed_menu_open() -> bool:
    return bed_menu.visible

func close_bed_menu() -> void:
    bed_menu.call("close_menu")

func _on_bed_sit_selected() -> void:
    bed_sit_selected.emit()

func _on_bed_sleep_hours_selected(hours: int) -> void:
    bed_sleep_hours_selected.emit(hours)
