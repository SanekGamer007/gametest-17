extends Control

#TODO: remove all this shit and make a separate settings_manager.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BoxContainer/VBoxContainer/EXIT.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
