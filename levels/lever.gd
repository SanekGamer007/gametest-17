extends "res://objects/lever/lever.gd"

func change_icon() -> void:
	Tools.change_window_icon(load("res://levels/test.png").get_image())
