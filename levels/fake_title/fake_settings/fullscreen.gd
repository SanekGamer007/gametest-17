extends Button

var format_text = "FULLSCREEN   %s"


func _ready() -> void:
	_on_settingsmanager_settings_change()
	SettingsManager.settings_change.connect(_on_settingsmanager_settings_change)


func _on_settingsmanager_settings_change() -> void:
	if SettingsManager.user_settings.fullscreen:
		text = format_text % "ON"
	else:
		text = format_text % "OFF"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("main_button"):
			_apply()


func _apply() -> void:
	if SettingsManager.user_settings.fullscreen:
		SettingsManager.set_fullscreen(false)
	else:
		SettingsManager.set_fullscreen(true)
