extends CanvasLayer

@onready var AnimPlay = $AnimationPlayer
const PLAYER_SCENE = preload("res://entities/chara/chara.tscn") 
var scene: String
var new_target_spawn_id: String
var animname: String
var function_name: String
var function_args: String

func _ready() -> void:
	$ColorRect.size = get_viewport().get_visible_rect().size

func change_scene(new_scene: String, target_spawn_id: String, fadespeed: String, func_name = null, func_args = null):
	GlobalVars.player_start_busy.emit() # 'busy' will work perfectly for disabling player movement.
	GlobalVars.close_all_ui.emit()
	new_target_spawn_id = target_spawn_id
	scene = new_scene
	match fadespeed:
		"none":
			animname = "fade_instant"
		"slow":
			animname = "fade_slow"
		"normal":
			animname = "fade"
		"fast":
			animname = "fade_fast"
		_:
			print(fadespeed + " is NOT a valid speed, defaulting to normal.")
			animname = "normal"
	AnimPlay.play(animname)
	AnimPlay.animation_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)
	
func _on_fade_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file(scene)
	await get_tree().scene_changed
	var player: Chara = get_tree().get_first_node_in_group("player")
	if not player:
		player = PLAYER_SCENE.instantiate()
		get_tree().current_scene.add_child(player)
	GlobalVars.player_stop_busy.emit()
	#update_pos.emit()
	_set_camera(player)
	AnimPlay.play_backwards(animname)


func _set_camera(player: Chara) -> void:
	var camera_bound: ReferenceRect
	var player_camera: Camera2D
	for i in get_tree().current_scene.get_children():
		if i is ReferenceRect and i.name == "CameraBounds":
			camera_bound = i
			break
	player_camera = player.get_node("Camera2D")
	if player_camera and camera_bound:
		var rect: Rect2 = camera_bound.get_global_rect()
		player_camera.limit_top = int(rect.position.y)
		player_camera.limit_bottom = int(rect.end.y)
		player_camera.limit_left = int(rect.position.x)
		player_camera.limit_right = int(rect.end.x)
	else:
		print("something went wrong")
		print(player_camera)
		print(camera_bound)
