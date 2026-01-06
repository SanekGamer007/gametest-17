extends Control

#TODO: remove all this shit and make a separate settings_manager.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title/EXIT.grab_focus()
