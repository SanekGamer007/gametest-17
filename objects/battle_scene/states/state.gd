extends Node
class_name BattleState

@onready var state_machine: BattleStateMachine = get_parent()
@onready var battle_scene: BattleScene = get_parent().get_parent()

func enter() -> void:
	pass

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
