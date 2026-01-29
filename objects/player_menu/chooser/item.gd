extends "res://objects/player_menu/chooser/button_icon.gd"

func _on_update_text(_lvl_data: LevelData) -> void:
	if GlobalVars.player_inventory.size() == 0:
		disabled = true
		$"../STAT".grab_focus()
		focus_mode = Control.FOCUS_NONE
