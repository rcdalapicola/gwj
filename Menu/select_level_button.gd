extends Button

@export var root: Node

func _ready():
	pressed.connect(root.select_level_pressed.bind(self.text))
