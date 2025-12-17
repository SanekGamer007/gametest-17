@tool
extends Area2D
const DIALOGUE_SYSTEM_PRELOAD = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
const DIALOGUE_TOP_OFFSET: Vector2 = Vector2(0, 16)
const DIALOGUE_BOTTOM_OFFSET: Vector2 = Vector2(0, 324)
var desired_dialogue_offset: Vector2
var activated: bool
@export var only_activate_once: bool = false ## Resets when re-entering the room.
@export var action: Action
@export var condition: bool = false: 
	set(value):
		condition = value
		notify_property_list_changed()
@export var operator: Tools.Operator
@export var flag_name: String
@export var flag_value: Variant
@export var var_name: String
@export var var_value: Variant
@export var target_path: NodePath

func _validate_property(property: Dictionary) -> void:
	if !condition:
		match property.name:
			"flag_name":
				property.usage = PROPERTY_USAGE_NO_EDITOR
			"flag_value":
				property.usage = PROPERTY_USAGE_NO_EDITOR
			"var_name":
				property.usage = PROPERTY_USAGE_NO_EDITOR
			"var_value":
				property.usage = PROPERTY_USAGE_NO_EDITOR
			"target_path":
				property.usage = PROPERTY_USAGE_NO_EDITOR
			"operator":
				property.usage = PROPERTY_USAGE_NO_EDITOR

func _on_body_entered(body: Node2D) -> void:
	if body is Chara:
		_do_action(body)

func _do_action(player: Chara) -> void:
	if activated:
		return
	if condition:
		var result: bool
		if flag_name:
			var flag_result = GlobalVars.get_flag(flag_name, Tools.get_zero_value(flag_value))
			result = Tools.compare(flag_result, flag_value, operator)
		elif var_name:
			var var_result = get_node(target_path).get(var_name)
			result = Tools.compare(var_result, var_value, operator)
		else:
			printerr("Invalid Condition.")
			return
		if !result:
			return
	if action is ActionFunction:
		visible = action.show_dialogue_box
		var target_node = get_node(action.target_path)
		if target_node.has_method(action.function_name):
			if action.function_arguments.size() == 0:
				target_node.call(action.function_name)
			else:
				target_node.callv(action.function_name, action.function_arguments)
	
	elif action is ActionSet:
		if action.flag_name:
			GlobalVars.set_flag(action.flag_name, action.flag_value)
		elif action.var_target_path:
			var node = action.var_target_path
			var vartoset = action.var_name
			var value = action.var_value
			get_node(node).set(vartoset, value) #there's a probably a safer way to do this.
		else: 
			printerr("Invalid ActionSet Type, Ignoring...")
	
	elif action is ActionDialogue:
		GlobalVars.player_start_busy.emit()
		var new_dialogue: DialogueBox = DIALOGUE_SYSTEM_PRELOAD.instantiate()
		if action.override_dialogue_offset:
			desired_dialogue_offset = action.override_offset
		else:
			if player.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
				desired_dialogue_offset = DIALOGUE_TOP_OFFSET
			else:
				desired_dialogue_offset = DIALOGUE_BOTTOM_OFFSET
		new_dialogue.offset = desired_dialogue_offset
		new_dialogue.current_dialogue = action.dialogue
		new_dialogue.dialogue_context = self
		get_tree().root.add_child(new_dialogue)
	
	elif action is Action:
		printerr("you forgot to set action type.")
	
	else:
		printerr("Invalid Action type, skipping.")
	if only_activate_once:
		activated = true
