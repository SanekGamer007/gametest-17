extends CanvasLayer

signal finished

func start_transition(button_pos: Vector2) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player is Chara:
		push_warning("Player not found, skipping anim...")
	else:
		var player_screen_space_pos = player.get_global_transform_with_canvas().origin
		$CharaAnimatedSprite2D.global_position = player_screen_space_pos
		$Heart.global_position = player_screen_space_pos
		var anim_name: String = player.get_node("AnimatedSprite2D").animation
		anim_name.replace("walk", "idle")
		$CharaAnimatedSprite2D.play(anim_name)
	var tween: Tween = create_tween()
	tween.tween_property($Heart, "visible", true, 0.075)
	tween.tween_callback($AudioStreamPlayer.play)
	tween.tween_property($Heart, "visible", false, 0.075)
	tween.tween_property($Heart, "visible", true, 0.075)
	tween.tween_callback($AudioStreamPlayer.play)
	tween.tween_property($Heart, "visible", false, 0.075)
	tween.tween_property($Heart, "visible", true, 0.075)
	tween.tween_callback($AudioStreamPlayer.play)
	tween.tween_property($CharaAnimatedSprite2D, "visible", false, 0)
	tween.tween_callback($AudioStreamPlayer2.play)
	tween.tween_property($Heart, "position", button_pos, 0.75)
	tween.tween_callback(finished.emit)
	tween.parallel().tween_property($ColorRect, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)
	tween.parallel().tween_property($Heart, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)
	tween.tween_callback(queue_free)
