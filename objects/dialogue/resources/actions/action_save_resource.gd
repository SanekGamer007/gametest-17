class_name ActionSave
extends Action

const SAVE_UI: PackedScene = preload("res://objects/saving_dialog/saving_dialog.tscn")

@export var force_version: GlobalVars.Versions = GlobalVars.Versions.ANY ## ANY is auto-select.
@export var spawnpoint: String = "A"
@export var show_dialogue_box: bool = false
