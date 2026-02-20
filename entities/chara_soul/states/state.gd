extends Node
class_name CharaSoulState

@onready var state_machine: CharaSoulStateMachine = get_parent()
@onready var chara_soul: CharaSoul = get_parent().get_parent()

func enter() -> void:
	pass

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
