extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_data: Dictionary = SaveManager.load_game()
	var save_data_vars = save_data.get("vars")

	if save_data == null or save_data == { }:
		save_data = { }
	if save_data_vars == null or save_data_vars == { }:
		save_data_vars = { }
	var play_time = (save_data_vars.get("player_time", 0) / 1000)

	$Save/Buttons/HBoxContainer/Continue.save_data = save_data

	$Save/Info/NAME.text = save_data_vars.get("player_name", "ERROR")
	$Save/Info/LV.text = "LV %s" % save_data_vars.get("player_love", "0")
	$Save/Info/TIME.text = Tools.time_to_string(play_time)
	if save_data_vars.get("player_room", "") != "":
		$Save/ROOM.text = SceneManager.get_level_title(save_data_vars.get("player_room"))
	else:
		$Save/ROOM.text = "ERROR"

	$Save/Buttons/HBoxContainer/Continue.grab_focus()
