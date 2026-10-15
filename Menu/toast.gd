extends Node2D

@onready var label: Label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Label
@onready var emote: TextureRect = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Emote

@export var fade_in_time: float = 0.3
@export var visible_time: float = 2.0
@export var fade_out_time: float = 0.3

func _ready():
	queue_free()
	modulate.a = 0.0
	
	var tween = create_tween()
	
	# Fade in
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time)
	
	# Wait
	tween.tween_interval(visible_time)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, fade_out_time)
	
	# Delete
	tween.tween_callback(queue_free)

func set_emote_visible(is_visible: bool):
	emote.visible = is_visible

func set_text(text : String):
	label.text = text
