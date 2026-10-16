extends Node

const toast_scene = preload("res://Menu/toast.tscn")
const instruction_scene = preload("res://Menu/instruction.tscn")

var current_emissor := 0
var score := 0
var score_enabled := false

@onready var ui_manager: UIManager


func toast(string: String, show_emote: bool = true) -> void:
	var toast = toast_scene.instantiate()
	ui_manager.add_child(toast)
	toast.set_emote_visible(show_emote)
	toast.set_text(string)

func useEmissor() -> int:
	current_emissor -= 1
	_updateUI()
	return current_emissor

func setEmissorAmount(total_emissors : int) -> void:
	current_emissor = total_emissors
	_updateUI()

func updateScore() -> void:
	score += current_emissor
	current_emissor = 0
	_updateUI()

func enableScore(enable : bool) -> void:
	score_enabled = enable
	
func isScoreEnabled() -> bool:
	return score_enabled

func addScore(points : int) -> void:
	score += points
	_updateUI()

func getEmissor() -> int:
	return current_emissor
	
func getScore() -> int:
	return score

func _updateUI() -> void:
	ui_manager.update_score_UI()

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
