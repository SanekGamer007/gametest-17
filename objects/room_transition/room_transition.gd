extends Area2D
class_name RoomTransition

@export_file("*.tscn") var room: String
@export var doorid: String = "A"
@export var fadespeed: String = "normal"
@export var func_location: String
@export var func_name: String
@export var func_args: Array[Variant]

func _on_body_entered(body: Node2D) -> void:
	if not room:
		return
	if body is Chara:
		SceneManager.change_scene(room, doorid, fadespeed, func_location, func_name, func_args)
