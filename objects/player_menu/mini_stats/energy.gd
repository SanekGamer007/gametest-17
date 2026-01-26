extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(lvl_data: LevelData):
	text = "EN  %s/%s" % [GlobalVars.player_en, GlobalVars.player_maxen]
	if lvl_data:
		if lvl_data.room_version <= GlobalVars.Versions.GAMETEST:
			visible = true
		else:
			visible = false
	else:
		visible = false
