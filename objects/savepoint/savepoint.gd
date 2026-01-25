extends Area2D

const DIALOGUE_SYSTEM_PRELOAD = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
var DIALOGUE_TOP_OFFSET: Vector2 = Vector2(0, 16)
var DIALOGUE_BOTTOM_OFFSET: Vector2 = Vector2(0, 324)
#@export var activate_instant: bool
@export_category("Dialogue Options")
@export var only_activate_once: bool
@export var override_ui_offset: bool
@export var override_offset: Vector2
@export var dialogue: Array[Dialogue]
#@export var spawn_at_root: bool = true

var desired_ui_offset: Vector2

var player_node: Chara = null


func _activate_dialogue() -> void:
	GlobalVars.player_start_busy.emit()
	var new_dialogue: DialogueBox = DIALOGUE_SYSTEM_PRELOAD.instantiate()
	if override_ui_offset:
		desired_ui_offset = override_offset
	else:
		if player_node.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
			desired_ui_offset = DIALOGUE_TOP_OFFSET
		else:
			desired_ui_offset = DIALOGUE_BOTTOM_OFFSET
	new_dialogue.offset = desired_ui_offset
	new_dialogue.current_dialogue = dialogue
	new_dialogue.context = self
	get_tree().root.add_child(new_dialogue)


func interaction(player: Node) -> void:
	GlobalVars.player_start_busy.emit()
	player_node = player
	$AudioStreamPlayer.play()
	_activate_dialogue()


func interaction_can_interact():
	return true
