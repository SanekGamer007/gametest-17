@icon("res://objects/dialogue/resources/icons/dialogue.svg")
extends Area2D

class_name DialogueInteraction
#@export var activate_instant: bool
@export_category("Dialogue Options")
@export var only_activate_once: bool
@export var override_offset: Vector2 = Vector2.INF
@export var dialogue: Array[DialogueSeriesResource]
#@export var spawn_at_root: bool = true

var dialogue_idx: int = 0

var has_activated_already: bool = false
var desired_dialogue_offset: Vector2

var player_node: Chara = null


func _activate_dialogue() -> void:
	if dialogue_idx >= dialogue.size() and !only_activate_once:
		dialogue_idx = dialogue.size() - 1
	Tools.start_dialogue(dialogue[dialogue_idx].dialogue, player_node, self, override_offset)
	if dialogue_idx >= dialogue.size():
		has_activated_already = true
	else:
		dialogue_idx += 1


func interaction(player: Node) -> void:
	player_node = player
	_activate_dialogue()


func interaction_can_interact():
	if dialogue_idx >= dialogue.size() and only_activate_once:
		return false
	else:
		return true
