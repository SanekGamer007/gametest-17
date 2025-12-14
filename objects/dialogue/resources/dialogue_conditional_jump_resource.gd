@icon("res://objects/dialogue/resources/icons/dialogue_conditional_jump.svg")
extends Dialogue
class_name DialogueConditionalJump

@export_group("Variable", "var_")
@export var var_target_path: NodePath
@export var var_variable: String ## Has to be comparable to the type of either variable two or variant.
@export var var_variant: Variant ## Has to be comparable to the type of variable.
@export var var_variable_two: String ## Variable two has priority over variant.
@export_group("Flag", "flag_")
@export var flag_name: String ## Has to be comparable to the type of either flag two or variant.
@export var flag_variant: Variant 
@export var flag_name_two: String

@export var jump_label_true: String
@export var jump_label_false: String
