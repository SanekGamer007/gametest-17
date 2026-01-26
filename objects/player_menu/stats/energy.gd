extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData):
	if owner.level_data:
		if owner.level_data.room_version == GlobalVars.Versions.GAMETEST or owner.level_data.room_version == GlobalVars.Versions.PROTO:
			text = "EN  %s / %s" % [GlobalVars.player_en, GlobalVars.player_maxen]
		else:
			text = ""
	else:
		text = ""
