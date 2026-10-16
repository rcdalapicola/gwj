extends CanvasLayer

signal exit_without_saving

@onready var input_name: LineEdit = $Panel/MenuButtons/InputName
@onready var score_label: Label = $Panel/MenuButtons/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "Score: " + str(GameManager.getScore())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_save_pressed() -> void:
	var name = input_name.text
	SilentWolf.Scores.save_score(name, GameManager.getScore())
	get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_exit_pressed() -> void:
	exit_without_saving.emit()
	queue_free()
