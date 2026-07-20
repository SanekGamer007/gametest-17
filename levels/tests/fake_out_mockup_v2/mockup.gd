extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	var player: Chara = get_tree().get_first_node_in_group("player")
	%PlayerLight.reparent(player)
	%PlayerLight.position = Vector2.ZERO
