extends Button

func _on_pressed() -> void:
	SettingsManager.save_settings()
	SceneManager.change_scene("res://levels/menu/real_title/real_title.tscn", "A", "none")
