extends Button

func _on_pressed() -> void:
	$"../../../Node2D".visible = true
	$"../..".visible = false

func _on_mouse_entered() -> void:
	$hover.play()

func _on_mouse_exited() -> void:
	$leave.play()
