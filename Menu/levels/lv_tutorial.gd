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
		"[center]\"Oh? Look what I found here! That old game that I could never even leave the tutorial level!\n\n Uhm... Now I'm a fully grown engineer, I make my own rules. I can use my [color=yellow]signal emissors[/color] to jam the game code! \n Who knows what effect exactly these emissors will have on the code? Well, it doesn't hurt to try!\"[/center]",
		"[center]Welcome to [color=yellow]Game Jamming[/color]!\n Your goal is to reach the flag on each level. To achieve that, you will need to place your [color=yellow]signal emissors[/color] to jam the game code and change the behaviour of the tiles.[/center]",
		"[center]If you run out of [color=yellow]Emissors[/color], or if you just want to restart the level, you can press [color=yellow]R[/color] (or a remapped key of your choice).[/center]",
		"[center]Whenever you finish a level, you will get points equal to the number of Emissors you still have. Whenever you restart a level, you lose 2 points.[/center]",
		"[center]Press [color=yellow]ESC[/color] to open the pause menu. You can reconfigure your inputs to move, jump and reset level.[/center]",
		"[center]Tiles and Emissors of different colors have different behaviours. Explore them to find out![/center]",
		"[center]That's it! Jam your way to victory, and have fun![/center]",
	])

func crack_cursor(active : bool):
	print(cursor)
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#cursor.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#cursor.visible = false
