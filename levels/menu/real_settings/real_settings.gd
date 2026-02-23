extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title/EXIT.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button"):
		if visible:
			$Title/EXIT.pressed.emit()
			get_viewport().set_input_as_handled()
