extends Button

func _on_pressed() -> void:
	SettingsManager.save_settings()
	SceneManager.change_scene("res://levels/fake_title/fake_title.tscn", "A", "none")
