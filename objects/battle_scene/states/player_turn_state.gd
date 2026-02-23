extends BattleState
class_name BattlePlayerTurnState

var buttons: HBoxContainer

@export var test_dialogue: Array[Dialogue]


enum states {
	AWAIT,
	CHOSE_ACTION,
	SELECT_TARGET,
	FIGHT,
	FIGHT_MINIGAME,
	ACT,
	ITEM,
	MERCY,
}

var current_state: states = states.AWAIT
var select_target_destination: states

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
		_:
			buttons = battle_scene.get_node("Buttons").get_node("Demo")
			buttons.visible = true
		
	set_state(states.CHOSE_ACTION)

func update(delta: float) -> void:
	match current_state:
		states.AWAIT:
			_handle_await_state(delta)
		states.CHOSE_ACTION:
			_handle_chose_action_state(delta)
		states.FIGHT:
			_handle_fight_state(delta)
		states.FIGHT_MINIGAME:
			_handle_fight_minigame_state(delta)
		states.ACT:
			_handle_act_state(delta)
		states.ITEM:
			_handle_item_state(delta)
		states.MERCY:
			_handle_mercy_state(delta)

func exit() -> void:
	pass

func _handle_await_state(_delta: float) -> void:
	pass

func _handle_chose_action_state(_delta: float) -> void:
	pass

func _handle_fight_state(_delta: float) -> void:
	pass

func _handle_fight_minigame_state(_delta: float) -> void:
	pass

func _handle_act_state(_delta: float) -> void:
	pass

func _handle_item_state(_delta: float) -> void:
	pass

func _handle_mercy_state(_delta: float) -> void:
	pass

func _on_fight_pressed() -> void:
	pass

func _on_act_pressed() -> void:
	pass

func _on_spell_pressed() -> void:
	pass

func _on_item_pressed() -> void:
	pass

func _on_mercy_pressed() -> void:
	pass

func show_() -> void:
	pass


func set_state(new_state: states) -> void:
	if new_state == states.CHOSE_ACTION:
		if buttons:
			var found: bool = false
			for button in buttons.get_children():
				if button is Button and button.was_pressed:
					button.grab_focus()
					found = true
					break
			if not found:
				buttons.get_child(0).call_deferred("grab_focus")
		else:
			push_error("Something went horribly wrong. " + str(battle_scene.battle_era))
		battle_scene.battle_box.set_dialogue(test_dialogue)
	
	current_state = new_state
