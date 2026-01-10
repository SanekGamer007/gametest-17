extends Button

func _on_pressed() -> void:
	GlobalVars.load_time = Time.get_ticks_msec()
	SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
