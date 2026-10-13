extends Control
## Menu pequeno e editável para sentar na cama ou escolher a duração do sono.

signal sit_selected
signal sleep_hours_selected(hours: int)
signal cancelled

@onready var _action_panel: VBoxContainer = $Card/ActionPanel
@onready var _hours_panel: VBoxContainer = $Card/HoursPanel

func _ready() -> void:
	$Card/ActionPanel/SitButton.pressed.connect(_on_sit_pressed)
	$Card/ActionPanel/SleepButton.pressed.connect(_on_sleep_pressed)
	$Card/ActionPanel/CancelButton.pressed.connect(_on_cancel_pressed)
	$Card/HoursPanel/Hour1.pressed.connect(_emit_hours.bind(1))
	$Card/HoursPanel/Hour2.pressed.connect(_emit_hours.bind(2))
	$Card/HoursPanel/Hour4.pressed.connect(_emit_hours.bind(4))
	$Card/HoursPanel/Hour6.pressed.connect(_emit_hours.bind(6))
	$Card/HoursPanel/Hour8.pressed.connect(_emit_hours.bind(8))
	$Card/HoursPanel/CancelButton.pressed.connect(_show_actions)
	if not Engine.is_editor_hint():
		close_menu()

func open_menu() -> void:
	_show_actions()
	show()

func close_menu() -> void:
	hide()

func _show_actions() -> void:
	_action_panel.show()
	_hours_panel.hide()

func _on_sit_pressed() -> void:
	close_menu()
	sit_selected.emit()

func _on_sleep_pressed() -> void:
	_action_panel.hide()
	_hours_panel.show()

func _on_cancel_pressed() -> void:
	close_menu()
	cancelled.emit()

func _emit_hours(hours: int) -> void:
	close_menu()
	sleep_hours_selected.emit(hours)
