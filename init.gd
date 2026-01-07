extends Node

func _ready() -> void:
	Tools.change_window_title(" ")
	SceneManager.change_scene("res://levels/fake_title/fake_title.tscn", "A", "none")
