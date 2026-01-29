extends Label

func _on_update_text(_lvl_data: LevelData):
	var next_exp_total = GlobalVars.get_required_exp(GlobalVars.player_love + 1)
	text = "NEXT: %s" % str(next_exp_total - GlobalVars.player_exp)
