extends "res://debug/debug_menu/blah/button_icon.gd"

func _on_pressed() -> void:
	var chara = get_tree().get_first_node_in_group("player")
	if not chara.get_node("CollisionShape2D").disabled:
		text = "NOCLIP (%s)" % "ON"
		chara.get_node("CollisionShape2D").disabled = true
	else:
		text = "NOCLIP (%s)" % "OFF"
		chara.get_node("CollisionShape2D").disabled = false
