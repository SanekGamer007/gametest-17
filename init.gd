extends Node

func _ready() -> void:
	get_window().borderless = false
	Tools.change_window_title(" ")
	SaveManager.load_sys_info_to_global(SaveManager.load_system_information())
	if true: # GlobalVars.has_beaten_demo == true:
		SceneManager.change_scene("res://levels/menu/real_intro/real_intro.tscn", "A", "none")
	else:
		SceneManager.change_scene("res://levels/menu/fake_title/fake_title.tscn", "A", "none")
