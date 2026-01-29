extends Label

func _on_update_text(lvl_data: LevelData):
	text = "L%s" % GlobalVars.player_love
	if lvl_data:
		if lvl_data.room_version <= GlobalVars.Versions.GAMETEST:
			visible = true
		else:
			visible = false
	else:
		visible = false
