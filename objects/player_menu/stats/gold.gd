extends Label

func _on_update_text(_lvl_data: LevelData):
	if owner.level_data:
		if owner.level_data.room_version == GlobalVars.Versions.RELEASE:
			text = "GOLD: %s" % [GlobalVars.player_gold]
		else:
			text = "GILD: %s" % [GlobalVars.player_gold]
	else:
		text = "GILD: %s" % [GlobalVars.player_gold]
