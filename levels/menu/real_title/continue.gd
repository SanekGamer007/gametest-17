extends Button

var save_data: Dictionary = { }


func _on_pressed() -> void:
	if save_data == null or save_data == { }:
		return

	if SaveManager.load_save_to_global(save_data) == false:
		push_error("Error loading the save file.")
		return

	GlobalVars.load_time = Time.get_ticks_msec()
	GlobalVars.update_vars()
	SceneManager.change_scene(GlobalVars.player_room, GlobalVars.player_room_spawnpoint, "none")
