@icon("res://objects/dialogue/resources/icons/move_resource.svg")
extends Dialogue
class_name DialogueMove

@export var show_dialogue_box: bool = false
@export var target_path: NodePath
@export var move_duration: float
@export var is_relative: bool = false
@export var move_location: Vector2
@export var await_end: bool = true
