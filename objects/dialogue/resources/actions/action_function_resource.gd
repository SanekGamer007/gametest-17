class_name ActionFunction
extends Action

@export var target_path: NodePath
@export var function_name: String
@export var function_arguments: Array
@export var show_dialogue_box: bool = true
@export var wait_time: float = 0.0 ## show dialogue box has to be disabled for this to work.
@export var wait_for_signal_to_continue: String = ""
