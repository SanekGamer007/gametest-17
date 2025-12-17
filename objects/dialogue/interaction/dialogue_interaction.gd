@icon("res://objects/dialogue/resources/icons/dialogue.svg")
extends Area2D
const DIALOGUE_SYSTEM_PRELOAD = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
var DIALOGUE_TOP_OFFSET: Vector2 = Vector2(0, 16)
var DIALOGUE_BOTTOM_OFFSET: Vector2 = Vector2(0, 324)
#@export var activate_instant: bool
@export_category("Dialogue Options")
@export var only_activate_once: bool
@export var override_dialogue_offset: bool
@export var override_offset: Vector2
@export var dialogue: Array[DialogueSeriesResource]
#@export var spawn_at_root: bool = true

var dialogue_idx: int = 0

var has_activated_already: bool = false
var desired_dialogue_offset: Vector2

var player_node: Chara = null

func _activate_dialogue() -> void:
	if dialogue_idx >= dialogue.size() and !only_activate_once:
		dialogue_idx = dialogue.size() - 1
	GlobalVars.player_start_busy.emit()
	var new_dialogue: DialogueBox = DIALOGUE_SYSTEM_PRELOAD.instantiate()
	if override_dialogue_offset:
		desired_dialogue_offset = override_offset
	else:
		if player_node.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
			desired_dialogue_offset = DIALOGUE_TOP_OFFSET
		else:
			desired_dialogue_offset = DIALOGUE_BOTTOM_OFFSET
	new_dialogue.offset = desired_dialogue_offset
	new_dialogue.current_dialogue = dialogue[dialogue_idx].dialogue
	new_dialogue.dialogue_context = self
	get_tree().root.add_child(new_dialogue)
	
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
