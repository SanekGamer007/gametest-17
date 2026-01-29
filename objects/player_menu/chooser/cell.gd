extends "res://objects/player_menu/chooser/button_icon.gd"

func _on_update_text(_lvl_data: LevelData) -> void:
	if GlobalVars.player_contacts.size() == 0:
		visible = false
