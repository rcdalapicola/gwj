extends CharacterBody2D
#@onready var arrow: AnimatedSprite2D = $Arrow

@onready var arrow: Sprite2D = $Arrow
@onready var sprite: Sprite2D = $Sprite
@onready var animation: AnimationPlayer = $Animation
@export var target: Area2D
@onready var jump_effect: AudioStreamPlayer = $SoundEffects/Jump

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var jumping = false

func _ready():
	if !target:
		arrow.visible = false

func _physics_process(delta: float) -> void:
	if target:
		arrow.rotation = arrow.global_position.angle_to_point(target.global_position)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta 

	jumping = !is_on_floor()

	# Handle jump.
	if Input.is_action_just_pressed("up") and !jumping:
		jump_effect.play(0.1)
		velocity.y = JUMP_VELOCITY
		jumping = true
		animation.play("jump")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		
		if !jumping:
			if direction > 0:
				animation.play("walk_right")
			else:
				animation.play("walk_left")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if !jumping:
			animation.play("idle")

	move_and_slide()
