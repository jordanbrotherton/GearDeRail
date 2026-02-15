extends Button

func _start():
	if OS.has_feature("web"):
		$".".visible = false

func _on_pressed() -> void:
	get_tree().quit()

func _on_mouse_entered() -> void:
	$hover.play()

func _on_mouse_exited() -> void:
	$hover.play()
