extends Node

class_name LevelData

@export_flags("NOCHARA", "CUSTOMCAMERA") var level_flags = 0x0
@export var room_version: GlobalVars.Versions = GlobalVars.Versions.GAMETEST
@export var display_name: String ## if not set will default to file name.
@export_group("BGM", "bgm_")
@export_file("*.ogg", "*.mp3", "*.wav") var bgm: String ## If the same as the one already playing it will continue playing what already is playing, if null it will stop.
@export var bgm_fadein: bool = true
@export var bgm_fadein_duration: float = 3.0
@export var bgm_fadeout: bool = true
@export var bgm_fadeout_duration: float = 3.0


func _ready() -> void:
	if display_name == "":
		display_name = get_tree().current_scene.get_name()
