extends Node
var current_song_path: String = ""
var tween: Tween

func start_song(file: String, fade_in: bool = true, fade_in_duration: float = 1.0, fade_out: bool = true, fade_out_duration: float = 1.0) -> Error:
	if current_song_path == file:
		return Error.OK
	elif current_song_path == "":
		fade_out = false
	if not ResourceLoader.exists(file):
		if OS.is_debug_build():
			push_error("Invalid music path.")
		return Error.ERR_FILE_NOT_FOUND
	var mus: AudioStream = load(file)
	if not mus:
		push_error("Music cannot be loaded.")
		return Error.ERR_FILE_CANT_OPEN
	if fade_in or fade_out:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		if fade_out:
			tween.tween_property($AudioStreamPlayer, "volume_db", -80.0, fade_out_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			
		tween.tween_callback(func(): 
			$AudioStreamPlayer.stream = mus 
			$AudioStreamPlayer.play() 
			$AudioStreamPlayer.volume_db = -80.0 if fade_in else -9.0
		)
		if fade_in:
			tween.tween_property($AudioStreamPlayer, "volume_db", -9.0, fade_in_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		tween.kill()
		$AudioStreamPlayer.volume_db = -9.0
		$AudioStreamPlayer.stream = mus
		$AudioStreamPlayer.play()
	current_song_path = file
	return Error.OK

func stop_song(fade_out: bool = true, fade_out_duration: float = 3.0) -> void:
	if fade_out:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property($AudioStreamPlayer, "volume_db", -80.0, fade_out_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_callback(func(): 
			$AudioStreamPlayer.stop()
			)
		current_song_path = ""
		return
	current_song_path = ""
	$AudioStreamPlayer.stop()

func _mute_song() -> void: # debug only
	$AudioStreamPlayer.volume_db = -80.0
