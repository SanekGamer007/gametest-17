extends Button

var format_text = "FPS LIMIT [WIP]   %s"

var fps_choices: Array = [
	30,
	60,
	0,
]

var selected: int = 0


func _ready() -> void:
	_on_settingsmanager_settings_change()
	SettingsManager.settings_change.connect(_on_settingsmanager_settings_change)
	selected = fps_choices.find(SettingsManager.user_settings.fps_limit)
	if fps_choices[selected] == 0:
		text = format_text % "V-SYNC"
	else:
		text = format_text % fps_choices[selected]


func _on_settingsmanager_settings_change() -> void:
	if fps_choices[selected] == 0:
		text = format_text % "V-SYNC"
	else:
		text = format_text % fps_choices[selected]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("left"):
			selected -= 1
			if selected == -1:
				selected = fps_choices.size() - 1
			_apply(fps_choices[selected])

		elif Input.is_action_just_pressed("right"):
			selected += 1
			if selected == fps_choices.size():
				selected = 0
			_apply(fps_choices[selected])


func _apply(value: int) -> void:
	SettingsManager.set_fpslimit(value)
