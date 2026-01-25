@icon("res://objects/dialogue/resources/icons/dialogue_choice.svg")
extends Dialogue

class_name DialogueChoice

@export var speaker_img: Texture
@export var speaker_img_hframes: int = 1
@export var speaker_img_rest_frame: int = 0

@export_multiline var text: String
@export_range(0.1, 30.0, 0.1) var text_speed: float = 24.0
@export var can_be_skipped: bool = true

@export var text_sound: AudioStream = preload("res://audio/sfx/dialogue/txt_generic_1.wav")
@export var text_volume_db: int
@export var text_volume_pitch_min: float = 1 # 0.9
@export var text_volume_pitch_max: float = 1 # 1.15
@export var choice_text: Array[String]
@export var choice_action_id: Array[Action] ## Action Null will go forward.
