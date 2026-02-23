extends CharaSoulState

func enter() -> void:
	chara_soul.get_node("CollisionShape2D").disabled = true

func exit() -> void:
	chara_soul.get_node("CollisionShape2D").disabled = false
