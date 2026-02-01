extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "ARMOR: %s" % GlobalVars.player_current_armor.item_name
