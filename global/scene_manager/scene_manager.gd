extends CanvasLayer

@onready var AnimPlay = $AnimationPlayer
var scene : NodePath
var new_target_spawn_id: String
var animname: String
var function_name: String
var function_args: String


func change_scene(new_scene: NodePath, target_spawn_id: String, fadespeed: String, func_name = null, func_args = null):
	GlobalVars.player_start_busy.emit() # 'busy' will work perfectly for disabling player movement.
	GlobalVars.close_all_ui.emit()
	new_target_spawn_id = target_spawn_id
	scene = new_scene
	match fadespeed:
		"slow":
			animname = "fade_slow"
		"normal":
			animname = "fade"
		"fast":
			animname = "fade_fast"
		_:
			print(fadespeed + " is NOT a valid speed, defaulting to normal.")
			animname = "fadein"
	AnimPlay.play(animname)
	AnimPlay.animation_finished.connect(_on_fade_finished, CONNECT_ONE_SHOT)
	
func _on_fade_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file(scene)
	GlobalVars.player_stop_busy.emit()
	#update_pos.emit()
	AnimPlay.play_backwards(animname)
