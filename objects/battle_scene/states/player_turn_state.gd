extends BattleState
class_name BattlePlayerTurnState

var buttons: HBoxContainer

@export var test_dialogue: Array[Dialogue]

func enter() -> void:
	print(battle_scene.battle_era)
	match battle_scene.battle_era:
		GlobalVars.Versions.GAMETEST:
			buttons = battle_scene.get_node("Buttons").get_node("GT7")
			buttons.visible = true
		GlobalVars.Versions.DEMO:
			buttons = battle_scene.get_node("Buttons").get_node("Demo")
			buttons.visible = true
		GlobalVars.Versions.RELEASE:
			buttons = battle_scene.get_node("Buttons").get_node("Demo")
			buttons.visible = true
	if buttons:
		buttons.get_child(1).call_deferred("grab_focus")
	else:
		push_error("Something went horribly wrong. " + str(battle_scene.battle_era))
	battle_scene.battle_box.set_dialogue(test_dialogue)

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
