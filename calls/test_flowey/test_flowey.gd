extends CellCallResource

@export var dialogue: Array[Dialogue]
@export var dialogue_testroom: Array[Dialogue]


func on_use() -> Array[Dialogue]:
	if GlobalVars.player_room == "res://levels/test_level.tscn":
		return dialogue_testroom
	return dialogue
