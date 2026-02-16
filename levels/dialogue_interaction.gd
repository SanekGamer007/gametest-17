extends DialogueInteraction

func interaction(player: Node) -> void:
	BattleManager.start_battle(true)
