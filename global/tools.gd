extends Node

enum Operator {
	EQUAL,
	NOT_EQUAL,
	GREATER,
	LESS,
	GREATER_EQUAL,
	LESS_EQUAL,
}


func compare(val_a: Variant, val_b: Variant, op: Operator) -> bool:
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


func get_zero_value(variable: Variant) -> Variant:
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


func get_target_node(path: NodePath, call_context: Node) -> Node:
	if path.is_empty():
		return call_context

	if path.is_absolute():
		return get_node(path)
	if call_context:
		return call_context.get_node(path)

	return get_node(path)


func change_window_title(title: String) -> void:
	get_window().title = title


func change_window_icon(icon: Image) -> void:
	DisplayServer.set_icon(icon)


func time_to_string(time_in_sec: int):
	var seconds = time_in_sec % 60
	var minutes = (time_in_sec / 60) % 60
	var hours = (time_in_sec / 60) / 60
	if hours != 0:
		return "%01d:%02d:%02d" % [hours, minutes, seconds]
	else:
		return "%01d:%02d" % [minutes, seconds]
