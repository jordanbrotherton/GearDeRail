class_name EnemyBomber
extends Node

@export var health: int = 1
@export var effect: PackedScene

func on_boom():
	health -= 1
	if effect:
		var e = effect.instantiate()
		e.global_position = get_parent().global_position
		get_parent().get_parent().add_child(e)
	if health <= 0:
		get_parent().queue_free()
