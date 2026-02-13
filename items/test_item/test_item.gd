extends ItemResource

@export var hp_heal: int


func on_use_overworld() -> Array[Dialogue]:
	var dialogue = DialogueText.new()

	if !GlobalVars.player_serious:
		dialogue.text = "You ate the %s.\nTastes like the color gray.\n" % item_name
	else:
		dialogue.text = "You ate the %s.\n" % item_name

	if not GlobalVars.player_hp + hp_heal >= GlobalVars.player_maxhp:
		dialogue.text = dialogue.text + "You recovered %shp!" % hp_heal
	else:
		dialogue.text = dialogue.text + "Your HP was maxed out."

	HpManager.heal_player(hp_heal)
	return [dialogue]


func on_use_battle() -> Array[Dialogue]:
	return on_use_overworld()
