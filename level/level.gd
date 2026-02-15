class_name Level
extends Node

@export var bombs: int = 3

signal is_done2

func _on_lever_is_done() -> void:
	is_done2.emit()
