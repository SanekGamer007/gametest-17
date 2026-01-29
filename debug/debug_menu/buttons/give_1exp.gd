extends "res://debug/debug_menu/blah/button_icon.gd"

func _on_pressed() -> void:
	GlobalVars.player_exp += 1
	GlobalVars.update_vars()
