extends Area2D

func interaction(_player: Chara = null) -> void:
	SceneManager.change_scene("res://levels/test_sequence/firstroom/firstroom.tscn", "A", "normal")

func interaction_can_interact():
	return true
