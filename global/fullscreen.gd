extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if SettingsManager.user_settings.fullscreen:
			SettingsManager.set_fullscreen(false)
		else:
			SettingsManager.set_fullscreen(true)
