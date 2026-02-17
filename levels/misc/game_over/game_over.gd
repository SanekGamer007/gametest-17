extends Control

@export var GameOverDialogueFirstDeath: Array[DialogueSeriesResource]
@export var GameOverDialogueNoKills: Array[DialogueSeriesResource]
@export var GameOverDialogueKills: Array[DialogueSeriesResource]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BgmManager.stop_song(false)
	$AnimationPlayer.play("anim")
	$VBoxContainer/TextWriter.set_process(false)
	$Heart/GPUParticles2D.amount = randi_range(4, 7)


func set_soul_pos(pos: Vector2) -> void:
	print(pos)
	$Heart.global_position = pos


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var dialogue: Array[Dialogue]
	if GlobalVars.player_deaths == 0 and false:
		var temp = GameOverDialogueFirstDeath.pick_random()
		dialogue = temp.dialogue
	elif GlobalVars.player_kills == 0:
		var temp = GameOverDialogueNoKills.pick_random()
		dialogue = temp.dialogue
	else:
		var temp = GameOverDialogueKills.pick_random()
		dialogue = temp.dialogue
	print(dialogue)
	$VBoxContainer/TextWriter.set_dialogue(dialogue)
	$VBoxContainer.visible = true
	$VBoxContainer/TextWriter.able_to_end = true
	$VBoxContainer/TextWriter.dialogue_end.connect(_on_death_dialogue_finished)

func _on_death_dialogue_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Fader, "modulate", Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await tween.finished
	if not SaveManager.save_file_exists():
		push_warning("Save file does not exist..")
		OS.alert("FATAL ERROR\nUnable to load the save file. exitting...", "FATAL ERROR")
		get_tree().quit(ERR_FILE_NOT_FOUND)
		return
	var save_data: Dictionary = SaveManager.load_game()
	if save_data.is_empty():
		push_error("Error loading the save file.")
		OS.alert("FATAL ERROR\nUnable to load the save file. exitting...", "FATAL ERROR")
		get_tree().quit(ERR_INVALID_DATA)
		return
	if not SaveManager.load_save_to_global(save_data):
		push_error("Error loading the save file.")
		OS.alert("FATAL ERROR\nUnable to load the save file. exitting...", "FATAL ERROR")
		get_tree().quit(ERR_INVALID_DATA)
		return
	GlobalVars.player_deaths += 1
	GlobalVars.update_vars()
	SceneManager.change_scene(GlobalVars.player_room, GlobalVars.player_room_spawnpoint, "normal")

func _play_music() -> void:
	BgmManager.start_song("res://audio/music/game_over/gameover.ogg", true, 2.0, true, 2.0)
	
	
	
