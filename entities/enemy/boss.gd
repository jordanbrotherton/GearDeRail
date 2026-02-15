extends AnimatedSprite2D

func _ready() -> void:
	play()

func _on_enemy_bomber_on_hit(new_health: int) -> void:
	$"..".queue_free()
