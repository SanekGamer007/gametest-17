extends Node2D
class_name BattleBox
var current_dialogue: Array[Dialogue]
var context: Node = null

func _ready() -> void:
	$TextWritter.current_dialogue = current_dialogue
	$TextWritter.context = context
	$TextWritter.request_visibility.connect(_set_visible)
	
func _set_visible(value: bool) -> void:
	$TextWritter.visible = value

func set_dialogue(dialogue: Array[Dialogue]) -> void:
	$TextWritter.set_dialogue(dialogue)
