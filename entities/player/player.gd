extends CharacterBody2D


@export var player_skin: Node2D

@export var SPEED = 400.0
@export var JUMP_VELOCITY = -400.0

var is_jumped: bool = false
var is_right: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			is_jumped = false
		elif !is_jumped:
			velocity.y = JUMP_VELOCITY
			is_jumped = true

	var was_right = is_right
	if velocity.x > 0: is_right = true
	elif velocity.x < 0: is_right = false
	if was_right != is_right:
		player_skin.scale.x *= -1


	move_and_slide()
