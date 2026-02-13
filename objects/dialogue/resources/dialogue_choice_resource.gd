@icon("res://objects/dialogue/resources/icons/dialogue_choice.svg")
extends DialogueText

class_name DialogueChoice

@export var choice_text: Array[String]
@export var choice_action_id: Array[Action] ## Action Null will go forward.
