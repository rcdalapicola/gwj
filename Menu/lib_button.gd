extends Node
class_name LibButton

@export var ease_type: Tween.EaseType
@export var trans_type: Tween.TransitionType
@export var anim_duration: float = 0.07
@export var scale_amount: Vector2 = Vector2(1.1, 1.1)
@export var rotation_amount: float = 0.5

@onready var button: Button = get_parent()

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_hovered.bind(true))
	button.mouse_exited.connect(_on_mouse_hovered.bind(false))
	button.pivot_offset_ratio = Vector2(0.5, 0.5)

func _on_mouse_hovered(hovered: bool):
	_reset_tween()
	tween.tween_property(button, "scale", scale_amount if hovered else Vector2.ONE, anim_duration)
	tween.tween_property(button,
	 					 "rotation_degrees",
		 				 rotation_amount * [-1, 1].pick_random() if hovered else 0.0,
						 anim_duration)

func _reset_tween():
	if tween:
		tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(trans_type).set_parallel(false)
