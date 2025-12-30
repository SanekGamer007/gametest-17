@icon("res://objects/dialogue/resources/icons/move_resource.svg")
extends DialogueTR
class_name DialogueToolMove

@export var target_path: NodePath
@export var move_duration: float
@export var is_relative: bool = false
@export var move_location: Vector2
@export var await_end: bool = true
