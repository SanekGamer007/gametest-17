extends Control
class_name BattleBox

var current_dialogue: Array[Dialogue]
@export var context: Node

func _ready() -> void:
	$TextWriter.able_to_end = false
	$TextWriter.context = context
	$TextWriter.request_visibility.connect(_set_visible)

func _set_visible(value: bool) -> void:
	$TextWriter.visible = value

func set_dialogue(dialogue: Array[Dialogue]) -> void:
	$TextWriter.set_dialogue(dialogue)

func reset_dialogue() -> void:
	$TextWriter.set_process(false)
	$TextWriter.next_item = false
	$TextWriter.current_dialogue = []
	$TextWriter.current_dialogue_item = 0

func set_box_size(size: Rect2) -> void:
	pass
