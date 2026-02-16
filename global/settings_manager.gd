extends Node

signal settings_change

const SAVE_PATH = "user://settings.cfg"

var default_settings = {
	"fullscreen": false,
	"wide_aspect_ratio": false,
	"fps_limit": 30,
	"integer_scaling": false,
	"language": 0,
	"mastervolume": 0.5,
	"soundvolume": 1,
	"musicvolume": 1,
}

var user_settings: Dictionary


func _ready() -> void:
	user_settings = default_settings.duplicate()
	_load_settings()
	get_window().move_to_center()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
		print_debug("Saved settings on exit!")


func save_settings() -> void:
	var settings = ConfigFile.new()
	settings.set_value("Video", "fullscreen", user_settings.fullscreen)
	settings.set_value("Video", "wide_aspect_ratio", user_settings.wide_aspect_ratio)
	settings.set_value("Video", "fps_limit", user_settings.fps_limit)
	settings.set_value("Video", "integer_scaling", user_settings.integer_scaling)
	settings.set_value("Game", "language", user_settings.language)
	settings.set_value("Sound", "mastervolume", snappedf(user_settings.mastervolume, 0.01))
	settings.set_value("Sound", "soundvolume", snappedf(user_settings.soundvolume, 0.01))
	settings.set_value("Sound", "musicvolume", snappedf(user_settings.musicvolume, 0.01))
	settings.save(SAVE_PATH)


func _load_settings() -> void:
	var settings = ConfigFile.new()
	var err = settings.load(SAVE_PATH)

	if err != OK:
		push_warning("Failed to load the save file, switching to using defaults...")
		_reset_settings()
		return

	for key in default_settings.keys():
		for section in settings.get_sections():
			if settings.has_section_key(section, key):
				user_settings[key] = settings.get_value(section, key, default_settings[key])
				break

	_apply_settings()


func _apply_settings() -> void:
	settings_change.emit()
	_apply_fullscreen()
	_apply_aspectratio()
	_apply_fpslimit()
	_apply_mastervolume()
	_apply_soundvolume()
	_apply_musicvolume()
	_apply_integer_scaling()


func _reset_settings() -> void:
	user_settings = default_settings.duplicate()
	_apply_settings()
	save_settings()


func set_fullscreen(value: bool) -> void:
	user_settings.fullscreen = value
	_apply_settings()


func _apply_fullscreen() -> void:
	if user_settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func set_aspectratio(value: bool) -> void:
	user_settings.wide_aspect_ratio = value
	_apply_settings()


func _apply_aspectratio() -> void:
	if user_settings.wide_aspect_ratio:
		get_window().size = Vector2i(854, 480)
		get_window().content_scale_size = Vector2i(854, 480)
	else:
		get_window().size = Vector2i(640, 480)
		get_window().content_scale_size = Vector2i(640, 480)


func set_fpslimit(value: int) -> void:
	user_settings.fps_limit = value
	_apply_settings()


func _apply_fpslimit() -> void:
	Engine.max_fps = user_settings.fps_limit


func set_integer_scaling(value: bool) -> void:
	user_settings.integer_scaling = value


func _apply_integer_scaling() -> void:
	if user_settings.integer_scaling == true:
		get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
	else:
		get_window().content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL


func set_mastervolume(value: float) -> void:
	value = clampf(value, 0, 1)
	user_settings.mastervolume = value
	_apply_settings()


func _apply_mastervolume() -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), user_settings.mastervolume)


func set_soundvolume(value: float) -> void:
	value = clampf(value, 0, 1)
	user_settings.soundvolume = value
	_apply_settings()


func _apply_soundvolume() -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Sounds"), user_settings.soundvolume)


func set_musicvolume(value: float) -> void:
	value = clampf(value, 0, 1)
	user_settings.musicvolume = value
	_apply_settings()


func _apply_musicvolume() -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), user_settings.musicvolume)
