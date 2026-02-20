extends Area2D

func interaction(_player: Chara = null) -> void:
	SceneManager.change_scene("res://levels/tests/corruption/test_corruption_level.tscn", "A", "normal")


func interaction_can_interact():
	return true
