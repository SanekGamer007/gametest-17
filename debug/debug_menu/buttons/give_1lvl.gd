extends "res://debug/debug_menu/blah/button_icon.gd"

func _on_pressed() -> void:
	GlobalVars.player_exp = GlobalVars.get_required_exp(GlobalVars.player_love + 1)
	GlobalVars.update_vars()
	GlobalVars.player_hp = GlobalVars.player_maxhp
	GlobalVars.player_en = GlobalVars.player_maxen
