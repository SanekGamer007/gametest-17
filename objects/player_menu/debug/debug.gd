extends CanvasLayer

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
	visible = false


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("second_button") or event.is_action_pressed("debug")) and visible:
		get_viewport().set_input_as_handled()
		visible = false
		GlobalVars.player_stop_busy.emit()
	elif event.is_action_pressed("debug") and not visible:
		visible = true
		_focus()
		GlobalVars.player_start_busy.emit()


func _focus() -> void:
	$PanelContainer/VBoxContainer/HBoxContainer/FullHeal.grab_focus()
