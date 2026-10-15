extends Node

signal pause(is_paused: bool)

@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var ui_manager: UIManager = $UIManager

var current_level: Node

var is_paused = false


func _unhandled_input(event):
	if $IntroMenu:
		return

	if event.is_action_pressed("pause"):
		pause.emit(!get_tree().paused)

func _on_quitting_game() -> void:
	#SilentWolf.Scores.save_score("Tester Player", 360)
	#return
	if OS.has_feature("web"):
		get_tree().reload_current_scene()
	else:
		get_tree().quit()

func handle_pause(is_paused: bool) -> void:
	pause_menu.display(is_paused)
	current_level.crack_cursor(!is_paused)
	get_tree().paused = is_paused

func _on_pause_change(is_paused: bool) -> void:
	handle_pause(is_paused)

func _on_pause_menu_resuming_game() -> void:
	handle_pause(false)

func _get_level(index: int) -> String:
	if index == 0:
		return "res://Menu/levels/lv_tut_01.tscn"
	
	if index >= 1 && index < 10:
		return "res://Menu/levels/lv_0" + str(index) + ".tscn"

	return ""

func _on_intro_menu_starting_game() -> void:
	_on_level_completed(1)
	$IntroMenu.queue_free()
	
func _on_level_completed(next_level: int):
	if current_level:
		current_level.queue_free()
		
	current_level = load(_get_level(next_level)).instantiate()
	print("Getting level: " + _get_level(next_level))
	current_level.level_completed.connect(_on_level_completed)
	get_tree().current_scene.add_child(current_level)
	#current_level.crack_cursor(true)
	#ui_manager.change_cursor(true)

func change_cursor(in_game : bool):
	if !current_level:
		return
		
	
	
	if in_game:
		current_level.crack_cursor(true)
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#current_level.visible = true
	else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		current_level.crack_cursor(false)
