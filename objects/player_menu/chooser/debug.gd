extends "res://objects/player_menu/chooser/button_icon.gd"

func _ready() -> void:
	visible = OS.is_debug_build()
