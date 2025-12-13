extends StaticBody2D

func interaction(_player: Chara = null) -> void:
	SceneManager.change_scene("res://levels/test_level.tscn", "A", "fast")

func interaction_can_interact():
	return true
