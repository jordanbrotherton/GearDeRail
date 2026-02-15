class_name EnemyBomber
extends Node

signal on_hit(new_health: int)

@export var health: int = 1
@export var effect: PackedScene

func on_boom():
	health -= 1
	on_hit.emit(health)
	if effect:
		var e = effect.instantiate()
		e.global_position = get_parent().global_position
		get_parent().get_parent().add_child(e)
	if health <= 0:
		get_parent().queue_free()
