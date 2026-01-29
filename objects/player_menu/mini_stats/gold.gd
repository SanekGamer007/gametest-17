extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "G   %s" % GlobalVars.player_gold
