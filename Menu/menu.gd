extends CanvasLayer

signal resuming_game
signal quitting_game

@onready var remap_screen: Panel = $RemapScreen
@onready var menu_buttons: VBoxContainer = $MenuButtons

func display(enabled: bool) -> void:
	if enabled:
		open()
	else:
		close()

func open() -> void:
	visible = true
	remap_screen.visible = false
	menu_buttons.visible = true

func close() -> void:
	visible = false

func _on_configure_input_pressed() -> void:
	remap_screen.open()
	menu_buttons.visible = false

func _on_remap_screen_screen_closing() -> void:
	remap_screen.visible = false
	menu_buttons.visible = true

func _on_resume_pressed() -> void:
	resuming_game.emit()

func _on_exit_pressed() -> void:
	quitting_game.emit()
