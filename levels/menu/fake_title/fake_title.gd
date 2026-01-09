extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_button"):
		GlobalVars.load_time = Time.get_ticks_msec()
		SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
