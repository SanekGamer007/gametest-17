@icon("res://objects/dialogue/resources/icons/wait_resource.svg")
@tool
extends DialogueTR
class_name DialogueToolWait

@export var wait_time: float = 1.0
@export var wait_for_signal: bool
@export var target_path: NodePath
@export var signal_name: String
