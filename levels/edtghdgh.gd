extends Area2D

func interaction(_player: Chara = null) -> void:
	SceneManager.change_scene("res://levels/tests/fakeout_test/fakeout_test.tscn", "A", "normal")


func interaction_can_interact():
	return true
