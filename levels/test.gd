extends StaticBody2D

func interaction(_player: Chara) -> void:
	rotation += 20

func interaction_can_interact():
	return true
