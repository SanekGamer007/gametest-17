extends Node

func _ready() -> void:
	get_window().borderless = false
	Tools.change_window_title(" ")
	SceneManager.change_scene("res://levels/menu/real_intro/real_intro.tscn", "A", "none")
