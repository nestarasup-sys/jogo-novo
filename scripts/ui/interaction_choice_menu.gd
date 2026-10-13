extends Control
## Menu reutilizável para as ações iniciais de móveis do quarto.

signal option_selected(option_id: String)
signal cancelled

@onready var _title: Label = $Card/Content/Title
@onready var _options: VBoxContainer = $Card/Content/Options
@onready var _cancel_button: Button = $Card/Content/CancelButton

func _ready() -> void:
	_cancel_button.pressed.connect(_cancel_menu)
	if not Engine.is_editor_hint():
		close_menu()

func open_menu(title: String, options: Array) -> void:
	_title.text = title
	_clear_options()
	for option in options:
		if not option is Dictionary:
			continue
		var option_id: String = str(option.get("id", ""))
		var label: String = str(option.get("label", ""))
		if option_id.is_empty() or label.is_empty():
			continue
		var button := Button.new()
		button.name = "Option_" + option_id
		button.text = label
		button.custom_minimum_size.y = 46.0
		button.pressed.connect(_select_option.bind(option_id))
		_options.add_child(button)
	show()

func close_menu() -> void:
	hide()

func _cancel_menu() -> void:
	close_menu()
	cancelled.emit()

func _clear_options() -> void:
	for child in _options.get_children():
		_options.remove_child(child)
		child.queue_free()

func _select_option(option_id: String) -> void:
	close_menu()
	option_selected.emit(option_id)
