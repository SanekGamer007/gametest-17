extends Area2D
const DialogSystemPreload = preload("res://objects/dialogue/dialogue_box/dialogue_box.tscn")
#@export var activate_instant: bool
@export var only_activate_once: bool
@export var override_dialogue_offset: bool
@export var override_offset: Vector2
@export var dialogue: Array[Dialogue]
@export var spawn_at_root: bool = false

var dialogue_top_offset: Vector2 = Vector2(32, 16)
var dialogue_bottom_offset: Vector2 = Vector2(32, 324)

#var player_body_in: bool = false
var has_activated_already: bool = false
var desired_dialogue_offset: Vector2

var player_node: Chara = null

func _activate_dialogue() -> void:
	GlobalVars.player_start_busy.emit()
	var new_dialogue = DialogSystemPreload.instantiate()
	if override_dialogue_offset:
		desired_dialogue_offset = override_offset
	else:
		if player_node.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y + 1:
			desired_dialogue_offset = dialogue_top_offset
		else:
			desired_dialogue_offset = dialogue_bottom_offset
	new_dialogue.offset = desired_dialogue_offset
	new_dialogue.current_dialogue = dialogue
	if spawn_at_root:
		get_tree().root.add_child(new_dialogue)
	else:
		add_sibling(new_dialogue)
	has_activated_already = true

func interaction(player: Node) -> void:
	player_node = player
	print(player_node)
	_activate_dialogue()

func interaction_can_interact():
	if only_activate_once and has_activated_already:
		return false
	else:
		return true
