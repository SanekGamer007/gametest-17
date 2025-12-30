extends CanvasLayer

@onready var AnimPlay = $AnimationPlayer
const PLAYER_SCENE = preload("res://entities/chara/chara.tscn") 
var scene: String
var new_target_spawn_id: String
var animname: String
var function_name: String
var function_args: String
var player: Chara
# LF = LevelFlag
const LF_NOCHARA = 0x1
const LF_CUSTOMCAMERA = 0x2

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
			push_error(fadespeed, " is not a valid speed, defaulting to normal.")
			animname = "fade"
	AnimPlay.play(animname)
	AnimPlay.animation_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)
	
func _on_fade_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file(scene)
	await get_tree().scene_changed
	_setup_level()
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
		if level_flags & LF_CUSTOMCAMERA:
			return
		var camera = Camera2D.new() # TODO: make a proper no chara camera.
		camera.zoom = Vector2(2, 2)
		get_tree().current_scene.add_child(camera)
	else:
		player = PLAYER_SCENE.instantiate()
		get_tree().current_scene.add_child(player)
		_set_camera()

func _set_camera() -> void:
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
		push_error("Failed to initialize camera bounds.")
		if OS.is_debug_build():
			if not player_camera:
				push_error("player_camera Not found.")
			if not camera_bound:
				push_error("camera_bound Not found.")
