extends DialogueInteraction

func interaction(player: Node) -> void:
	print(GlobalVars.get_flag("testflag", false))
	super(player)


func cam_shake() -> void:
	var shake = PCamShake.new()
	shake.apply_preset(shake.Preset.GUNSHOT)
	procam.add_addon(shake)
	shake.shake()
