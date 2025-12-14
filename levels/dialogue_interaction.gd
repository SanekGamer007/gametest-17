extends "res://objects/dialogue/interaction/dialogue_interaction.gd"

func interaction(player: Node) -> void:
	print(GlobalVars.get_flag("testflag", false))
	super(player)
