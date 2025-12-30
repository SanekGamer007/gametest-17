extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_button"):
		SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_S:
		SceneManager.change_scene("res://levels/fake_title/fake_settings/fake_settings.tscn", "A", "none")
