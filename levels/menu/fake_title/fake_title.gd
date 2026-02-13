extends Control

var new_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not SaveManager.save_file_exists():
		_prep_new_save()
		return
	var save_data: Dictionary = SaveManager.load_game()
	var save_data_vars = save_data.get("vars", { })

	if save_data == null or save_data == { }:
		save_data = { }
	if save_data_vars == null or save_data_vars == { }:
		save_data_vars = { }
	var play_time = (save_data_vars.get("player_time", 0) / 1000)

	$Save/Buttons/HBoxContainer/Continue.save_data = save_data

	$Save/Info/NAME.text = save_data_vars.get("player_name", "ERROR")
	$Save/Info/LV.text = "LV %s" % GlobalVars.get_level_from_exp(save_data_vars.get("player_exp", 0))
	$Save/Info/TIME.text = Tools.time_to_string(play_time)
	if save_data_vars.get("player_room", "") != "":
		$Save/ROOM.text = SceneManager.get_level_title(save_data_vars.get("player_room"))
	else:
		$Save/ROOM.text = "ERROR"

	$Save/Buttons/HBoxContainer/Continue.grab_focus()


func _prep_new_save() -> void:
	$Save.visible = false
	$NewSave.visible = true
	new_game = true

func _input(event: InputEvent) -> void:
	if not new_game:
		return
	if event.is_action_pressed("main_button"):
		SceneManager.change_scene("res://levels/menu/start_game/start_game.tscn", "A", "none", ".", "fake_title_ready")
