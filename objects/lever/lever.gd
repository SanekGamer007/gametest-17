extends Area2D

const DIALOGUE_SYSTEM_PRELOAD = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
const DIALOGUE_TOP_OFFSET: Vector2 = Vector2(0, 16)
const DIALOGUE_BOTTOM_OFFSET: Vector2 = Vector2(0, 324)

@export var mode: LeverModeResource
@export var only_activate_once: bool ## after action true or end of any other it will stop doing anything.
@export var action_after_first_activation: Action ## after action true or end of any other it will keep doing this.

var desired_dialogue_offset: Vector2
var has_activated: bool = false
var context: Node = self


func interaction(player: Node) -> void:
	if has_activated:
		if action_after_first_activation:
			_do_action(action_after_first_activation, player)
			return
	if mode == null:
		$AnimatedSprite2D.play("pressed")
		$AudioStreamPlayer2D.play()
		has_activated = true
		return
	match mode.get_script():
		LeverActionModeResource:
			_do_action(mode.action, player)
		LeverCheckModeResource:
			var result_one: Variant
			var result_two: Variant
			var result: bool
			match mode.value_one.get_script():
				ConditionalActionFlag:
					if !GlobalVars.has_flag(mode.value_one.name):
						result_one = false
					result_one = GlobalVars.get_flag(mode.value_one.name)
				ConditionalActionVar:
					result_one = Tools.get_target_node(mode.value_one.target_path, context).get(mode.value_one.name)
				ConditionalActionVariant:
					result_one = mode.value_one.value
			match mode.value_two.get_script():
				ConditionalActionFlag:
					if !GlobalVars.has_flag(mode.value_two.name):
						result_two = false
					result_two = GlobalVars.get_flag(mode.value_two.name)
				ConditionalActionVar:
					result_two = Tools.get_target_node(mode.value_two.target_path, context).get(mode.value_two.name)
				ConditionalActionVariant:
					result_two = mode.value_two.value
			result = Tools.compare(result_one, result_two, mode.operator)
			if result:
				_do_action(mode.action_true, player)
			else:
				_do_action(mode.action_false, player)
	$AnimatedSprite2D.play("pressed")
	$AudioStreamPlayer2D.play()
	has_activated = true


func interaction_can_interact():
	if only_activate_once and has_activated:
		return false
	else:
		return true


func _do_action(actionresource: Action, player: Chara) -> void:
	if actionresource is ActionFunction:
		var target_node = Tools.get_target_node(actionresource.target_path, context)
		if target_node.has_method(actionresource.function_name):
			if actionresource.function_arguments.size() == 0:
				target_node.call(actionresource.function_name)
			else:
				target_node.callv(actionresource.function_name, actionresource.function_arguments)

	elif actionresource is ActionSet:
		if actionresource.flag_name:
			GlobalVars.set_flag(actionresource.flag_name, actionresource.flag_value)
		elif actionresource.var_target_path:
			var node = actionresource.var_target_path
			var vartoset = actionresource.var_name
			var value = actionresource.var_value
			Tools.get_target_node(node, context).set(vartoset, value) #there's a probably a safer way to do this.
		else:
			push_error("Invalid ActionSet parameters, ignoring...")

	elif actionresource is ActionDialogue:
		GlobalVars.player_start_busy.emit()
		var new_dialogue: DialogueBox = DIALOGUE_SYSTEM_PRELOAD.instantiate()
		if actionresource.override_dialogue_offset:
			desired_dialogue_offset = actionresource.override_offset
		else:
			if player.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
				desired_dialogue_offset = DIALOGUE_TOP_OFFSET
			else:
				desired_dialogue_offset = DIALOGUE_BOTTOM_OFFSET
		new_dialogue.offset = desired_dialogue_offset
		new_dialogue.current_dialogue = actionresource.dialogue
		new_dialogue.context = self
		get_tree().root.add_child(new_dialogue)

	elif actionresource is Action:
		printerr("you forgot to set action type.")


func play(anim: String) -> void:
	$AnimatedSprite2D.play(anim)
