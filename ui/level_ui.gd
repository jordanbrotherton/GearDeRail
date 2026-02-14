extends Control

@export var bomb_label: Label


func update_bomb(count):
	bomb_label.text = str(count)
