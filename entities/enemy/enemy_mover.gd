class_name EnemyMover
extends CharacterBody2D


@export var SPEED = 300.0

@export var direction = 1

@export var floor_ray_l: RayCast2D
@export var floor_ray_r: RayCast2D

@export var ray_l: RayCast2D
@export var ray_r: RayCast2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if !floor_ray_l.is_colliding():
		direction = 1
	elif !floor_ray_r.is_colliding():
		direction = -1
	elif ray_l.is_colliding():
		if ray_l.get_collider() is not Player:
			direction = 1
	elif ray_r.is_colliding():
		if ray_r.get_collider() is not Player:
			direction = -1
	
	velocity.x = direction * SPEED

	move_and_slide()
