extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_mouse_entered() -> void:
	$hover.play()

func _on_mouse_exited() -> void:
	$leave.play()
