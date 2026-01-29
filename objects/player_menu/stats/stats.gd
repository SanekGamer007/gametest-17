extends Control

signal exit


func _ready() -> void:
	await owner.update_text
	if owner.level_data:
		var ministatsize = $"../MiniStats/PanelContainer".get_combined_minimum_size()
		if ministatsize.x >= 135:
			$PanelContainer.position.x += ministatsize.x - 135


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button") and visible:
		get_viewport().set_input_as_handled()
		exit.emit()
		visible = false
