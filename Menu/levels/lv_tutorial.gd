extends Node

@onready var cursor: Sprite2D = $Cursor

signal level_completed(next_level: int)

func _ready():
	crack_cursor(false)
	
	# Start tutorial after 0.5 seconds
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.autostart = true
	timer.timeout.connect(_start_tutorial)
	add_child(timer)

func _start_tutorial():
	GameManager.tutorial_step([
		"[center]Welcome to [color=yellow]Game Jamming[/color]![/center]",
		"[center]Oh? Look what I found here! That old game that I could never even leave the tutorial level!\n\n Uhm... Now I'm a fully grown engineer, I make my own rules. I can use my signal emissors to jam the game code! \n Who knows what effect exactly these emissors will have on the code? Well, it doesn't hurt to try![/center]",
		"[center]Press [color=yellow]ESC[/color] to open the pause menu. You can reconfigure your inputs to move, jump, reset level[/center]",
		"[center]Click anywhere to place a signal emissor. Emissors of different colors have different effects.[/center]"
	])

func crack_cursor(active : bool):
	print(cursor)
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#cursor.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#cursor.visible = false
