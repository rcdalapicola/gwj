extends Node

@onready var cursor: Sprite2D = $Cursor

signal level_completed(next_level: int)

func _ready():
	crack_cursor(true)

func crack_cursor(active : bool):
	print(cursor)
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#cursor.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#cursor.visible = false
