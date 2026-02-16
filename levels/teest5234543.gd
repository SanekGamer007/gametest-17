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
@export var item: ItemResource
#@export var spawn_at_root: bool = true

var dialogue_idx: int = 0

var has_activated_already: bool = false
var desired_dialogue_offset: Vector2

var player_node: Chara = null


func _activate_dialogue() -> void:
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
	new_dialogue.current_dialogue = item.on_use_overworld()
	new_dialogue.context = self
	get_tree().root.add_child(new_dialogue)


func interaction(player: Node) -> void:
	player_node = player
	GlobalVars.add_item(load("res://items/equipment/HeroSword/hero_sword.tres"))
	SystemUI.add_text_helper("Gave the hero's sword.", 3, 0)


func interaction_can_interact():
	return true
