extends Node

signal pause(is_paused: bool)

@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var ui_manager: UIManager = $UIManager
@onready var menu_buttons: Control = $IntroMenu/Panel/MenuButtons
@onready var start_menu_buttons: Control = $IntroMenu/Panel/StartMenuButtons
@onready var start_menu_level_selection: Control = $IntroMenu/Panel/StartMenuLevelSelection
@onready var score: Control = $UIManager/Score

var current_level: Node

var is_paused = false

const last_level = 9

func _unhandled_input(event):
	if $IntroMenu and $IntroMenu.visible:
		return

	if event.is_action_pressed("pause"):
		pause.emit(!get_tree().paused)

func _on_quitting_game() -> void:
	#SilentWolf.Scores.save_score("Tester Player", 360)
	#return
	#if OS.has_feature("web"):
	# On the title screen, "exit" quits the game.
	if $IntroMenu and $IntroMenu.visible:
		get_tree().quit()
		return

	# In-game: go back to the original menu without reloading the scene
	if current_level and is_instance_valid(current_level):
		var lvl = current_level
		current_level = null
		lvl.queue_free()

	get_tree().paused = false
	is_paused = false
	GameManager.resetScore()
	GameManager.enableScore(false)
	score.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if pause_menu:
		pause_menu.display(false)

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if $IntroMenu:
		$IntroMenu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if menu_buttons:
			menu_buttons.visible = true
		if start_menu_buttons:
			start_menu_buttons.visible = false
		if start_menu_level_selection:
			start_menu_level_selection.visible = false
	#else:
		#get_tree().quit()

func handle_pause(is_paused: bool) -> void:
	if not current_level or not is_instance_valid(current_level):
		return
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
	
func _get_level_emissor(index: int) -> int:
	match index:
		0:
			return 100
		1:
			return 5
		2:
			return 10
		3: 
			return 12
		4:
			return 10
		5:
			return 10
		6:
			return 6
		7:
			return 12
		8:
			return 14
		9:
			return 14
		
	return 0

func _on_intro_menu_starting_game() -> void:
	menu_buttons.visible = false
	start_menu_buttons.visible = true
	
func _on_intro_menu_start_tutorial() -> void:
	GameManager.resetScore()
	_on_level_completed(0)
	GameManager.enableScore(true)
	if $IntroMenu:
		$IntroMenu.visible = false
	
func _on_intro_menu_start_skip_tutorial() -> void:
	GameManager.resetScore()
	_on_level_completed(1)
	GameManager.enableScore(true)
	if $IntroMenu:
		$IntroMenu.visible = false
	
func _on_intro_menu_start_back() -> void:
	start_menu_buttons.visible = false
	menu_buttons.visible = true

func select_level_pressed(button_string : String) -> void:
	GameManager.resetScore()
	_on_level_completed(button_string.to_int())
	GameManager.enableScore(false)
	if $IntroMenu:
		$IntroMenu.visible = false

func _on_level_completed(next_level: int):
	if current_level:
		current_level.crack_cursor(false)
		current_level.queue_free()
		
	get_tree().paused = false
	is_paused = false
	pause_menu.display(false)

	GameManager.updateScore()

	if next_level > last_level:
		if !GameManager.isScoreEnabled():
			GameManager.resetScore()
		var scene = load("res://Menu/custom_menu.tscn").instantiate()
		scene.exit_without_saving.connect(_on_custom_menu_exit)
		get_tree().current_scene.add_child(scene)
		return

	GameManager.setEmissorAmount(_get_level_emissor(next_level))

	current_level = load(_get_level(next_level)).instantiate()
	current_level.crack_cursor(true)
	current_level.level_completed.connect(_on_level_completed)
	get_tree().current_scene.add_child(current_level)
	#current_level.crack_cursor(true)
	#ui_manager.change_cursor(true)

func _on_intro_menu_play_level() -> void:
	start_menu_buttons.visible = false
	start_menu_level_selection.visible = true
	#SilentWolf.Scores.save_score("Ruddy", 100)
	#get_tree().change_scene_to_file("res://addons/silent_wolf/examples/CustomLeaderboards/ReverseLeaderboard.tscn")
	#get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")
	
	#pass

func _on_intro_menu_level_selection_back() -> void:
	start_menu_level_selection.visible = false
	start_menu_buttons.visible = true

func _on_custom_menu_exit() -> void:
	get_tree().paused = false
	is_paused = false
	GameManager.resetScore()
	GameManager.enableScore(false)
	score.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if $IntroMenu:
		$IntroMenu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if menu_buttons:
			menu_buttons.visible = true
		if start_menu_buttons:
			start_menu_buttons.visible = false
		if start_menu_level_selection:
			start_menu_level_selection.visible = false

func _ready() -> void:
	SilentWolf.configure_scores({
	"open_scene_on_close": "res://Menu/menu.tscn"
  })
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	if $IntroMenu and $IntroMenu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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


func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")
