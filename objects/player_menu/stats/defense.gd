extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData):
	text = "DF  %s (%s)" % [GlobalVars.player_df, GlobalVars.player_base_df] # TODO FIXME change to armor at
