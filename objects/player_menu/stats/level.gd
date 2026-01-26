extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData):
	text = "LV  %s" % GlobalVars.player_love
