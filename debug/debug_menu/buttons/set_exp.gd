extends "res://debug/debug_menu/blah/button_icon.gd"

func _on_pressed() -> void:
	var num: String = $LineEdit.text
	if int(num) != null and int(num) >= 1:
		GlobalVars.player_exp = int(num)
		GlobalVars.update_vars()
