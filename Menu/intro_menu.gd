extends CanvasLayer

signal starting_game
signal quitting_game

@onready var remap_screen: Panel = $RemapScreen
@onready var menu_buttons: Control = $Panel/MenuButtons

func _ready() -> void:
	if $"../UIManager/Score":
		$"../UIManager/Score".visible = false

func _on_configure_input_pressed() -> void:
	remap_screen.open()
	menu_buttons.visible = false

func _on_remap_screen_screen_closing() -> void:
	remap_screen.visible = false
	menu_buttons.visible = true

func _on_exit_pressed() -> void:
	quitting_game.emit()

func _on_start_pressed() -> void:
	starting_game.emit()
