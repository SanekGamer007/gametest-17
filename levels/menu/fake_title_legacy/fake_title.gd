extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_button"):
		var data = SaveManager.load_game()
		SaveManager.load_save_to_global(data)
		GlobalVars.load_time = Time.get_ticks_msec()
		GlobalVars.update_vars()
		SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
