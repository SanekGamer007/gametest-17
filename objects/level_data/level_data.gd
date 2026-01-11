extends Node

class_name LevelData

@export_flags("NOCHARA", "CUSTOMCAMERA") var level_flags = 0x0
@export var room_version: GlobalVars.versions = GlobalVars.versions.GAMETEST
@export var bgm: AudioStream ## If the same as the one already playing it will continue playing what already is playing, if null it will stop.
@export var display_name: String ## if not set will default to file name.


func _ready() -> void:
	if display_name == "":
		display_name = get_tree().current_scene.get_name()
