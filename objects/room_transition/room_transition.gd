extends Area2D

@export_file("*.tscn") var room: String
@export var doorid: String = "A"
@export var fadespeed: String = "normal"
@export var func_name: Variant
@export var func_args: Variant

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if not room:
		print(room)
		return
	if body is Chara:
		SceneManager.change_scene(room, doorid, fadespeed, func_name, func_args)
