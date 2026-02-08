extends Button


func _on_pressed() -> void:
	SceneManager.change_scene("res://levels/menu/start_game/start_game.tscn", "A", "none", ".", "real_title_ready")
