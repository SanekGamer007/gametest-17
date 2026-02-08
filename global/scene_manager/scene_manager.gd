extends CanvasLayer

# LF = LevelFlag
const LF_NOCHARA = 0x1
const LF_CUSTOMCAMERA = 0x2

const PLAYER_SCENE = preload("res://entities/chara/chara.tscn")

var scene: String
var new_target_spawn_id: String
var animname: String
var function_location: String
var function_name: String
var function_args: Array
var player: Chara

@onready var AnimPlay = $AnimationPlayer


func change_scene(new_scene: String, target_spawn_id: String, fadespeed: String, func_location: String = "", func_name: String = "", func_args: Array = []):
	$ColorRect.size = get_viewport().get_visible_rect().size
	GlobalVars.player_start_busy.emit() # 'busy' will work perfectly for disabling player movement.
	GlobalVars.close_all_ui.emit()
	new_target_spawn_id = target_spawn_id
	scene = new_scene
	function_location = func_location
	function_name = func_name
	function_args = func_args
	match fadespeed:
		"none":
			$ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
			animname = "fade_instant"
		"slow":
			$ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
			animname = "fade_slow"
		"normal":
			$ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
			animname = "fade"
		"fast":
			$ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
			animname = "fade_fast"
		"white_slow":
			$ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
			animname = "fade_slow"
		"white_normal":
			$ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
			animname = "fade"
		"white_fast":
			$ColorRect.color = Color(1.0, 1.0, 1.0, 1.0)
			animname = "fade_fast"
		_:
			push_error(fadespeed, " is not a valid speed, defaulting to normal.")
			$ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
			animname = "fade"
	AnimPlay.play(animname)
	AnimPlay.animation_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)


func _on_fade_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file(scene)
	await get_tree().scene_changed
	GlobalVars.player_room = scene
	_setup_level()
	var target_node = get_tree().current_scene.get_node_or_null(function_location)
	if target_node and target_node.has_method(function_name):
		if function_args is Array and not function_args.is_empty():
			target_node.callv(function_name, function_args)
		else:
			target_node.call(function_name)
	else:
		if OS.is_debug_build():
			push_warning("Target node or function not found.", target_node, function_location, function_name)
	AnimPlay.play_backwards(animname)


func _setup_level() -> void:
	var level_flags = 0
	var level_data = get_tree().current_scene.get_node_or_null("LevelData")
	if level_data:
		level_flags = level_data.level_flags
	else:
		push_warning("Scene: " + get_tree().current_scene.name + " Doesn't contain a LevelData node, skipping level flags...")
	GlobalVars.player_stop_busy.emit()
	if level_flags & LF_NOCHARA:
		return
	if level_flags & LF_CUSTOMCAMERA:
		player = PLAYER_SCENE.instantiate()
		player.get_node("Camera2D").enabled = false
		get_tree().current_scene.add_child(player)
	else:
		player = PLAYER_SCENE.instantiate()
		get_tree().current_scene.add_child(player)
		_set_camera()


func _set_camera() -> void:
	var camera_bound: ReferenceRect
	var player_camera: Camera2D

	camera_bound = get_tree().get_first_node_in_group("cam_bound")

	player_camera = player.get_node("Camera2D")

	if player_camera and camera_bound:
		var rect: Rect2 = camera_bound.get_global_rect()
		player_camera.limit_top = int(rect.position.y)
		player_camera.limit_bottom = int(rect.end.y)
		player_camera.limit_left = int(rect.position.x)
		player_camera.limit_right = int(rect.end.x)
	else:
		push_error("Failed to initialize camera bounds.")
		if OS.is_debug_build():
			if not camera_bound:
				push_error("camera_bound Not found.")


func get_level_title(path: String) -> String:
	var levelscene: PackedScene = load(path)
	if levelscene == null:
		return ""
	var level: Node = levelscene.instantiate()
	var leveldata: LevelData = level.get_node_or_null("LevelData")
	var room_name: String

	if leveldata:
		room_name = leveldata.display_name
		if room_name == "":
			room_name = level.name

	level.free()
	return room_name
