extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "HP  %s / %s" % [GlobalVars.player_hp, GlobalVars.player_maxhp]
