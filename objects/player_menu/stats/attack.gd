extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData):
	text = "AT  %s (%s)" % [GlobalVars.player_at, GlobalVars.player_base_at] # TODO FIXME change to weapon at
