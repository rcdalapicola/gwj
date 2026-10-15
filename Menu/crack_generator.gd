extends Node2D
class_name LevelManager

var fade_tween: Tween
var is_resetting := false

@export var current_level_index : int

@export var scene_to_spawn: PackedScene
@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var color_rect: ColorRect = $"../ColorRect"


func _ready() -> void:
	GameManager.toast("Level " + str(current_level_index))

func spawn_scene_at_mouse():
	var new_scene = scene_to_spawn.instantiate()
	if "player" in new_scene:
		new_scene.player = $"../Player"
	new_scene.global_position = get_global_mouse_position()
	get_parent().add_child(new_scene)

func _reset():
	if is_resetting:
		return
	
	is_resetting = true
	get_parent().level_completed.emit(current_level_index)

func _input(event):
	if Input.is_action_just_pressed("click"):
		spawn_scene_at_mouse()
	if Input.is_action_just_pressed("reset"):
		_reset()

func _on_flag_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		fade_to_black()
		
func cancel_fade():
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
		color_rect.color.a = 0

func fade_to_black():
	if fade_tween:
		fade_tween.kill()

	fade_tween = create_tween()
	fade_tween.tween_property(color_rect, "color:a", 1.0, 3.0)
	
	await fade_tween.finished
	is_resetting = true
	get_parent().level_completed.emit(current_level_index + 1)

func _on_flag_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		cancel_fade()

func _on_playable_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_reset()
