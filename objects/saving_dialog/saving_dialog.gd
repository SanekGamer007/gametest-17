extends CanvasLayer

var version: GlobalVars.Versions = GlobalVars.Versions.ANY # auto detect
var spawnpoint: String = "A"

var NAME_PLACEHOLDER = "%s"
var LEVEL_PLACEHOLDER = "%d"
var TIME_PLACEHOLDER = "%s"
var ROOMNAME_PLACEHOLDER = "%s"

@onready var save_dict = SaveManager.load_game()
@onready var save_dict_vars: Dictionary = save_dict.get("vars", { })

@onready var save_player_name = save_dict_vars.get("player_name", GlobalVars.player_name)
@onready var save_player_love = save_dict_vars.get("player_love", GlobalVars.player_love)
@onready var save_player_time = save_dict_vars.get("player_time", GlobalVars.player_time)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button"):
		_on_return_pressed()


func _ready() -> void:
	$Demo.visible = false
	$GMT7.visible = false
	GlobalVars.player_start_busy.emit()
	GlobalVars.close_all_ui.connect(_on_ui_quit)

	if get_tree().current_scene.get_node_or_null("LevelData") and version == GlobalVars.Versions.ANY:
		version = get_tree().current_scene.get_node_or_null("LevelData").room_version
	elif version == GlobalVars.Versions.ANY:
		version = GlobalVars.Versions.DEMO
	match version:
		GlobalVars.Versions.PROTO:
			_setup_proto_dialog()
		GlobalVars.Versions.GAMETEST:
			_setup_gmt7_dialog()
		GlobalVars.Versions.DEMO:
			_setup_demo_dialog()
		GlobalVars.Versions.RELEASE:
			_setup_release_dialog()
		_:
			push_error("wtf how.")
			_setup_demo_dialog()


func _setup_proto_dialog() -> void:
	_setup_gmt7_dialog() # placeholder


func _save_proto_dialog() -> void:
	_save_gmt7_dialog()


func _setup_gmt7_dialog() -> void:
	$GMT7.visible = true

	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/NAME.text = NAME_PLACEHOLDER % save_player_name
	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/LEVEL.text = LEVEL_PLACEHOLDER % save_player_love
	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/TIME.text = TIME_PLACEHOLDER % str(save_player_time / 1000)

	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/Save.grab_focus()


func _save_gmt7_dialog() -> void:
	var session_time: int = Time.get_ticks_msec() - GlobalVars.load_time
	var play_time: int = GlobalVars.player_time + session_time

	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/NAME.text = NAME_PLACEHOLDER % GlobalVars.player_name
	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/LEVEL.text = LEVEL_PLACEHOLDER % GlobalVars.player_love
	$GMT7/BoxContainer/VBoxContainer/HBoxContainer/TIME.text = TIME_PLACEHOLDER % str(play_time / 1000)

	SaveManager.save_game()
	SaveManager.save_system_information()


func _setup_demo_dialog() -> void:
	$Demo.visible = true
	LEVEL_PLACEHOLDER = "LV %s"

	$Demo/BoxContainer/VBoxContainer/HBoxContainer/NAME.text = NAME_PLACEHOLDER % save_dict_vars.player_name
	$Demo/BoxContainer/VBoxContainer/HBoxContainer/LEVEL.text = LEVEL_PLACEHOLDER % save_dict_vars.player_love
	$Demo/BoxContainer/VBoxContainer/HBoxContainer/TIME.text = TIME_PLACEHOLDER % Tools.time_to_string(save_dict_vars.player_time / 1000)

	var room_name: String = "ERROR"
	if get_tree().current_scene.get_node_or_null("LevelData"):
		room_name = get_tree().current_scene.get_node_or_null("LevelData").display_name
	else:
		room_name = get_tree().current_scene.name

	$Demo/BoxContainer/VBoxContainer/ROOMNAME.text = ROOMNAME_PLACEHOLDER % room_name

	$Demo/BoxContainer/VBoxContainer/HBoxContainer2/Save.grab_focus()


func _save_demo_dialog() -> void:
	var session_time: int = Time.get_ticks_msec() - GlobalVars.load_time
	var play_time: int = GlobalVars.player_time + session_time

	$Demo/BoxContainer/VBoxContainer/HBoxContainer/NAME.text = NAME_PLACEHOLDER % GlobalVars.player_name
	$Demo/BoxContainer/VBoxContainer/HBoxContainer/LEVEL.text = LEVEL_PLACEHOLDER % GlobalVars.player_love
	$Demo/BoxContainer/VBoxContainer/HBoxContainer/TIME.text = TIME_PLACEHOLDER % Tools.time_to_string(play_time / 1000)

	SaveManager.save_game()
	SaveManager.save_system_information()


func _setup_release_dialog() -> void:
	_setup_demo_dialog() # placeholder


func _save_release_dialog() -> void:
	_save_demo_dialog()


func _on_save_pressed() -> void:
	GlobalVars.player_room_spawnpoint = spawnpoint

	match version:
		GlobalVars.Versions.PROTO:
			_save_proto_dialog()
		GlobalVars.Versions.GAMETEST:
			_save_gmt7_dialog()
		GlobalVars.Versions.DEMO:
			_save_demo_dialog()
		GlobalVars.Versions.RELEASE:
			_save_release_dialog()
		_:
			push_error("wtf how.")
			_save_demo_dialog()


func _on_return_pressed() -> void:
	GlobalVars.player_stop_busy.emit()
	queue_free()


func _on_ui_quit() -> void:
	queue_free()
