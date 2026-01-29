extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "LV  %s" % GlobalVars.player_love
