extends "res://objects/lever/lever.gd"

func interaction_can_interact():
	return false


func _on_body_entered(body: Node2D) -> void:
	if has_activated:
		return
	if body is Chara:
		interaction(body)
