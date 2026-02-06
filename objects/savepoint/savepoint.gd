extends Area2D

@export_category("Savepoint Options")
@export var override_offset: Vector2 = Vector2.INF
@export var dialogue: Array[Dialogue]


func interaction(player: Node) -> void:
	GlobalVars.player_start_busy.emit()
	$AudioStreamPlayer.play()
	Tools.start_dialogue(dialogue, player, self, override_offset)


func interaction_can_interact():
	return true
