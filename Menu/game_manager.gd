extends Node

const toast_scene = preload("res://Menu/toast.tscn")
const instruction_scene = preload("res://Menu/instruction.tscn")

@onready var ui_manager: UIManager


func toast(string: String, show_emote: bool = true) -> void:
	var toast = toast_scene.instantiate()
	ui_manager.add_child(toast)
	toast.set_emote_visible(show_emote)
	toast.set_text(string)


func instruction(bbcode_text: String) -> void:
	var instruction = instruction_scene.instantiate()
	ui_manager.add_child(instruction)
	instruction.set_text(bbcode_text)


func tutorial_step(steps: Array[String]) -> void:
	if steps.is_empty():
		return
	
	_tutorial_steps = steps
	_tutorial_index = 0
	_show_next_tutorial_step()

func _show_next_tutorial_step():
	if _tutorial_index >= _tutorial_steps.size():
		return
	
	var instruction = instruction_scene.instantiate()
	ui_manager.add_child(instruction)
	instruction.set_text(_tutorial_steps[_tutorial_index])
	
	instruction.finished.connect(_on_tutorial_step_finished)

func _on_tutorial_step_finished():
	_tutorial_index += 1
	_show_next_tutorial_step()

var _tutorial_steps: Array[String] = []
var _tutorial_index: int = 0
