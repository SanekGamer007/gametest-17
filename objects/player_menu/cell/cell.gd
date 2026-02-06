extends Control

const CELLBUTTON = preload("res://objects/player_menu/cell/cell_button/cell_button.tscn")

@onready var cell_add_location = $PanelContainer/HBoxContainer/VBoxContainer

signal exit


func _on_update_text(_lvl_data: LevelData) -> void:
	if owner.level_data:
		var ministatsize = $"../MiniStats/PanelContainer".get_combined_minimum_size()
		if ministatsize.x >= 135:
			$PanelContainer.position.x += ministatsize.x - 135
	for child in cell_add_location.get_children():
		if child is Button:
			child.queue_free()
	for i: CellCallResource in GlobalVars.player_contacts:
		var cellphone: Button = CELLBUTTON.instantiate()
		cellphone.cellresource = i
		cellphone.calling.connect(_on_call)
		cell_add_location.add_child(cellphone)
		cellphone.prep()


func do_focus() -> void:
	for i in cell_add_location.get_children():
		if i is Button:
			i.grab_focus()
			break


func _on_call(caller: CellCallResource) -> void:
	visible = false
	var desired_dialogue_offset
	if owner.player_menu_up_offset:
		desired_dialogue_offset = Tools.DIALOGUE_BOTTOM_OFFSET
	else:
		desired_dialogue_offset = Tools.DIALOGUE_TOP_OFFSET
	owner.sub_ui_dialogue = true
	await Tools.start_dialogue(caller.on_use(), null, self, desired_dialogue_offset)
	GlobalVars.close_all_ui.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button") and visible:
		get_viewport().set_input_as_handled()
		exit.emit()
		visible = false
