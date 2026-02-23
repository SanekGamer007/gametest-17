extends DialogueInteraction
@export var test: BattleResource

func interaction(player: Node) -> void:
	BattleManager.start_battle(test)
