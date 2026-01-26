extends Label

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData):
	text = "ARMOR: %s" % "TODO" # TODO: implement
