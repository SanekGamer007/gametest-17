@icon("res://objects/dialogue/resources/icons/dialogue.svg")
class_name DialogueBox
extends CanvasLayer
var current_dialogue: Array[Dialogue]
var context: Node = null

func _ready() -> void:
	$TextWritter.current_dialogue = current_dialogue
	$TextWritter.context = context
	$TextWritter.dialogue_end.connect(_on_dialogue_end)
	$TextWritter.request_visibility.connect(_set_visible)

func _set_visible(value: bool) -> void:
	visible = value

func _on_dialogue_end() -> void:
	queue_free()
	GlobalVars.player_stop_busy.emit()
