extends Node
class_name ButtonReplicator

@export var template_button: Button

@onready var child_buttons#: Array = get_parent().get_children(false)


func copy_theme_overrides(from_button: Button, to_button: Button):
	if !from_button:
		return

	# Copy styleboxes
	for type in ["normal", "hover", "pressed", "disabled", "focus"]:
		var style = from_button.get_theme_stylebox(type)
		if style:
			to_button.add_theme_stylebox_override(type, style.duplicate())

	# Copy font colors
	for color_name in ["font_color", "font_hover_color", "font_pressed_color", "font_disabled_color"]:
		var color = from_button.get_theme_color(color_name)
		to_button.add_theme_color_override(color_name, color)

	# Copy font size
	var font_size = from_button.get_theme_font_size("font_size")
	to_button.add_theme_font_size_override("font_size", font_size)

func set_template(button: Button):
	template_button = button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	replicate()

func replicateButton(button: Button) -> void:
	copy_theme_overrides(template_button, button)

func replicate() -> void:
	child_buttons = get_parent().find_children("*", "Button", true)
	print("All children found: " + str(child_buttons))
	for button in child_buttons:
		replicateButton(button)
	if template_button:
		template_button.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
