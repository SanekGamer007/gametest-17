@icon("res://objects/dialogue/resources/icons/wait_resource.svg")
extends Dialogue
class_name DialogueWait

@export var show_dialogue_box: bool = false
@export var wait_time: float = 1.0
@export var wait_for_signal: bool
@export var target_path: NodePath
@export var signal_name: String
