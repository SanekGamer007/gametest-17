extends Label

func _on_update_text(lvl_data: LevelData):
	text = "LV  %s" % GlobalVars.player_love
	if lvl_data:
		if lvl_data.room_version >= GlobalVars.Versions.DEMO:
			visible = true
		else:
			visible = false
	else:
		visible = false
