extends Node

enum Operator {
	EQUAL,          # ==
	NOT_EQUAL,      # !=
	GREATER,        # >
	LESS,           # <
	GREATER_EQUAL,  # >=
	LESS_EQUAL      # <=
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
			return {}
		_:
			return null
