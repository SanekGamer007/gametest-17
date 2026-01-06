extends Node

func _ready() -> void:
	get_window().title = " "
	SceneManager.change_scene("res://levels/fake_title/fake_title.tscn", "A", "none")
