extends Resource
class_name BattleResource

@export var intro: bool = false
@export var monsters: Array[PackedScene] ## Due to godot not having strongly typed PackedScenes we cant restrict this in ui. This only accepts the Monster class.
@export var background: PackedScene
@export var version: GlobalVars.Versions
