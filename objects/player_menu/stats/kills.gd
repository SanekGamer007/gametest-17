extends Label

func _on_update_text(_lvl_data: LevelData):
	if GlobalVars.player_kills < 20:
		visible = false
	else:
		visible = true
		text = "KILLS: %s" % GlobalVars.player_kills
