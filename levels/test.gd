extends Area2D

func interaction(_player: Chara = null) -> void:
	SceneManager.change_scene("res://levels/intro/intro_01/intro_01.tscn", "A", "normal")


func interaction_can_interact():
	return true
