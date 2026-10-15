extends Node2D

@onready var rich_text: RichTextLabel = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/RichTextLabel
@onready var continue_hint: Label = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer2/ContinueHint

@export var fade_in_time: float = 0.5
@export var fade_out_time: float = 0.3

signal finished

var _finished: bool = false

func _ready():
	modulate.a = 0.0
	print("Instruction ready: rich_text = ", rich_text, " text = '", rich_text.text, "'")
	print("RichTextLabel visible: ", rich_text.visible, " rect: ", rich_text.get_rect())
	
	# Pause the game
	get_tree().paused = true
	
	# Setup continue hint
	if continue_hint:
		continue_hint.text = "(press anything to continue...)"
		continue_hint.visible = true
	
	# Fade in
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	# Wait for any input
	await _wait_for_any_input()
	
	# Fade out
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_out_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	
	# Unpause and cleanup
	get_tree().paused = false
	finished.emit()
	queue_free()

func _wait_for_any_input():
	while is_inside_tree():
		# Check for any input action being pressed
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel") or \
		   Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or \
		   Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or \
		   Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("click") or \
		   Input.is_action_just_pressed("ui_select"):
			break
		await get_tree().process_frame
	_finished = true

func set_text(bbcode_text: String):
	print("Instruction.set_text called with: ", bbcode_text)
	if rich_text:
		rich_text.text = bbcode_text
		print("RichTextLabel text set to: ", rich_text.text)
	else:
		print("ERROR: rich_text is null!")

func is_finished() -> bool:
	return _finished
