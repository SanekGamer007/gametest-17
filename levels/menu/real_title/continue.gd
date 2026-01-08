extends Button

func _on_pressed() -> void:
	SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
