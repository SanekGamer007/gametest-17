extends DialogueInteraction

func interaction(player: Node) -> void:
	print(GlobalVars.get_flag("testflag", false))
	super(player)
