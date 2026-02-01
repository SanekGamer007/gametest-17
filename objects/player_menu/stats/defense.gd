extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "DF  %s (%s)" % [GlobalVars.player_df, GlobalVars.player_bonus_df] # TODO FIXME change to armor at
