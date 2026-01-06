extends Button

var format_text = "MASTER VOLUME   %s"


func _ready() -> void:
	_on_settingsmanager_settings_change()
	SettingsManager.settings_change.connect(_on_settingsmanager_settings_change)


func _on_settingsmanager_settings_change() -> void:
	text = format_text % (str(SettingsManager.user_settings.mastervolume * 100).pad_decimals(0) + "%")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_focus():
		if Input.is_action_pressed("left"):
			_apply(-0.005)
		elif Input.is_action_pressed("right"):
			_apply(0.005)


func _apply(value: float) -> void:
	SettingsManager.set_mastervolume(SettingsManager.user_settings.mastervolume + value)
