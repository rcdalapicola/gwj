extends Node

@onready var cursor: Sprite2D = $Cursor

signal level_completed(next_level: int)

func _ready():
	crack_cursor(true)

func crack_cursor(active : bool):
	if active:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		var c = find_child("Cursor")
		if c:
			c.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var c = find_child("Cursor")
		if c:
			c.visible = false
