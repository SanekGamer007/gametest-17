extends Node

const DIALOGUE_SYSTEM_PRELOAD = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
const DIALOGUE_TOP_OFFSET: Vector2 = Vector2(0, 16)
const DIALOGUE_BOTTOM_OFFSET: Vector2 = Vector2(0, 324)

enum Operator {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	LESS,
	GREATER_EQUAL,
	LESS_EQUAL,
}


static func compare(val_a: Variant, val_b: Variant, op: Operator) -> bool:
	if typeof(val_a) != typeof(val_b):
		return false
	match op:
		Operator.EQUAL:
			return val_a == val_b
		Operator.NOT_EQUAL:
			return val_a != val_b
		Operator.GREATER:
			return val_a > val_b
		Operator.LESS:
			return val_a < val_b
		Operator.GREATER_EQUAL:
			return val_a >= val_b
		Operator.LESS_EQUAL:
			return val_a <= val_b
		_:
			return false


static func get_zero_value(variable: Variant) -> Variant:
	match typeof(variable):
		TYPE_BOOL:
			return false
		TYPE_INT:
			return 0
		TYPE_FLOAT:
			return 0.0
		TYPE_STRING:
			return ""
		TYPE_VECTOR2:
			return Vector2.ZERO
		TYPE_COLOR:
			return Color.BLACK
		TYPE_ARRAY:
			return []
		TYPE_DICTIONARY:
			return { }
		_:
			return null


static func change_window_title(window: Window, title: String) -> void:
	window.title = title


static func change_window_icon(icon: Image) -> void:
	DisplayServer.set_icon(icon)


static func time_to_string(time_in_sec: int):
	var seconds = time_in_sec % 60
	var minutes = (time_in_sec / 60) % 60
	var hours = (time_in_sec / 60) / 60
	if hours != 0:
		return "%01d:%02d:%02d" % [hours, minutes, seconds]
	else:
		return "%01d:%02d" % [minutes, seconds]


static func get_current_room() -> String:
	if GlobalVars.player_room.begins_with("res://"):
		return GlobalVars.player_room

	if ResourceUID.ensure_path(GlobalVars.player_room):
		return ResourceUID.get_id_path(ResourceUID.text_to_id(GlobalVars.player_room))
	else:
		if OS.is_debug_build():
			push_error("Invalid player room.")
		return ""


func get_target_node(path: NodePath, call_context: Node) -> Node:
	if path.is_empty():
		return call_context

	if path.is_absolute():
		return get_node(path)
	if call_context:
		return call_context.get_node(path)

	return get_node(path)

func start_dialogue(dialogue: Array[Dialogue], player_node: Chara = null, context: Node = self, override_offset: Vector2 = Vector2.INF) -> bool:
	# checks
	if dialogue == null or dialogue.is_empty():
		if OS.is_debug_build():
			push_error("Dialogue array is empty.")
		return false
	elif player_node == null and override_offset == Vector2.INF:
		if OS.is_debug_build():
			push_error("Player node is null and custom offset is not supplied.")
		override_offset = DIALOGUE_BOTTOM_OFFSET # recovery
	elif context == self: # may end up causing a lot of trouble if not set.
		if OS.is_debug_build():
			push_error("FATAL: Invalid context, exitting...")
		return false

	var desired_dialogue_offset
	GlobalVars.player_start_busy.emit()
	var new_dialogue: DialogueBox = DIALOGUE_SYSTEM_PRELOAD.instantiate()
	if override_offset != Vector2.INF:
		desired_dialogue_offset = override_offset
	else:
		if player_node.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
			desired_dialogue_offset = DIALOGUE_TOP_OFFSET
		else:
			desired_dialogue_offset = DIALOGUE_BOTTOM_OFFSET
	new_dialogue.offset = desired_dialogue_offset
	new_dialogue.current_dialogue = dialogue
	new_dialogue.context = context
	get_tree().root.add_child(new_dialogue)
	await new_dialogue.tree_exiting
	return true
