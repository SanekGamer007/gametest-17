extends Area2D

func interaction(_player: Chara = null) -> void:
	if Input.is_action_pressed("second_button"):
		SceneManager.change_scene("res://levels/tests/fake_out_mockup_v2/mockup.tscn", "A", "normal")
	else:
		SceneManager.change_scene("res://levels/tests/fakeout_test/fakeout_test.tscn", "A", "normal")


func interaction_can_interact():
	return true
