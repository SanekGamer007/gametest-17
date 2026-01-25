extends Button

var format_text = "ASPECT RATIO [WIP]   %s"


func _ready() -> void:
	_on_settingsmanager_settings_change()
	SettingsManager.settings_change.connect(_on_settingsmanager_settings_change)


func _on_settingsmanager_settings_change() -> void:
	if SettingsManager.user_settings.wide_aspect_ratio:
		text = format_text % "WIDESCREEN"
	else:
		text = format_text % "CLASSIC"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("main_button"):
			_apply()


func _apply() -> void:
	if SettingsManager.user_settings.wide_aspect_ratio:
		SettingsManager.set_aspectratio(false)
		get_window().move_to_center()
	else:
		SettingsManager.set_aspectratio(true)
		get_window().move_to_center()
