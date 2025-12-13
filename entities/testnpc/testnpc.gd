extends StaticBody2D
signal cutscenedone

func cutscenefunction() -> void: # just a comment
	$AnimatedSprite2D.play("left_walk")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(-64, position.y), 1)
	await tween.finished
	$AnimatedSprite2D.play("left_idle")
	await get_tree().create_timer(0.5).timeout
	cutscenedone.emit(true)
