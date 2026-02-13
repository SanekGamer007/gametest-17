extends Label

func _on_update_text(_lvl_data: LevelData):
	text = "HP  %s/%s" % [GlobalVars.player_hp, GlobalVars.player_maxhp]
	if HpManager.karma_amount > 0:
		self_modulate = Color(1.0, 0.0, 1.0, 1.0)
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)
