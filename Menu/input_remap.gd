extends Panel

signal screen_closing

@onready var button_remap = preload("res://Menu/button_remap.tscn")
@onready var input_remap: VBoxContainer = $MarginContainer/ScrollInputRemap/MarginContainer/InputRemap
@onready var button_replicator: ButtonReplicator = $MarginContainer/ScrollInputRemap/MarginContainer/InputRemap/ButtonReplicator

@export var background_color: Color
@export var template_button: Button

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up": "Jump",
	"right": "Move right",
	"left": "Move left",
	"reset": "Reset level",
	"pause": "Pause",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_replicator.set_template(template_button)

func open() -> void:
	_create_action_list()
	visible = true
	
func _create_action_list():
	InputMap.load_from_project_settings()
	for item in input_remap.get_children():
		if item is Button:
			item.queue_free()
		
	for action in input_actions:
		var button = button_remap.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelKey")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" - Physical")
		else:
			input_label.text = ""
		
		button_replicator.replicateButton(button)
		input_remap.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelKey").text = "Press key to bind..."
		
func _input(event):
	if is_remapping:
		if (event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)):
				InputMap.action_erase_events(action_to_remap)
				InputMap.action_add_event(action_to_remap, event)
				_update_action_list(remapping_button, event)
				
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				accept_event()
				
func _update_action_list(button, event):
	button.find_child("LabelKey").text = event.as_text().trim_suffix(" - Physical")


func _on_button_back_pressed() -> void:
	screen_closing.emit()
