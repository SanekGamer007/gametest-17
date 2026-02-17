extends BattleState
class_name BattleStartState


func enter() -> void:
	state_machine.change_state.call_deferred("PlayerTurnState")

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
