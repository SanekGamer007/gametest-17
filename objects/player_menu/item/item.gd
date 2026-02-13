extends Control

signal exit

const ITEMBUTTON = preload("res://objects/player_menu/item/item_button/item_button.tscn")

var focus_memory: Button
var active_item_id: int = -1

@onready var item_add_location = $PanelContainer/HBoxContainer/ItemContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button") and visible:
		get_viewport().set_input_as_handled()
		if focus_memory:
			focus_memory.grab_focus()
			focus_memory = null
			active_item_id = -1
			$PanelContainer/VBoxContainer/HBoxContainer/USE.focus_mode = Control.FOCUS_NONE
			$PanelContainer/VBoxContainer/HBoxContainer/INFO.focus_mode = Control.FOCUS_NONE
			$PanelContainer/VBoxContainer/HBoxContainer/DROP.focus_mode = Control.FOCUS_NONE
			return
		exit.emit()
		visible = false


func do_focus() -> void:
	for i in item_add_location.get_children():
		if i is Button:
			i.grab_focus()
			break


func _on_update_text(_lvl_data: LevelData) -> void:
	if visible:
		return
	for child in item_add_location.get_children():
		if child is Button:
			child.queue_free()
	for i: int in GlobalVars.player_inventory.size():
		var itembutt: Button = ITEMBUTTON.instantiate()
		itembutt.item_id = i
		itembutt.text = GlobalVars.player_inventory[i].item_name
		itembutt.using.connect(_on_use)
		item_add_location.add_child(itembutt)


func _on_use(item_id: int, button: Button) -> void:
	focus_memory = button
	active_item_id = item_id
	$PanelContainer/VBoxContainer/HBoxContainer/USE.focus_mode = Control.FOCUS_ALL
	$PanelContainer/VBoxContainer/HBoxContainer/INFO.focus_mode = Control.FOCUS_ALL
	$PanelContainer/VBoxContainer/HBoxContainer/DROP.focus_mode = Control.FOCUS_ALL
	$PanelContainer/VBoxContainer/HBoxContainer/USE.grab_focus()


func _on_use_pressed() -> void:
	if active_item_id == -1:
		return
	var item = GlobalVars.player_inventory[active_item_id]
	if item is EquipmentResource:
		_start_dialogue(GlobalVars.equip_item(active_item_id))
		owner.force_update_text()
		return
	if item.consume_on_use:
		GlobalVars.remove_item_by_id(active_item_id)
	active_item_id = -1
	_start_dialogue(item.on_use_overworld())
	owner.force_update_text()


func _on_info_pressed() -> void:
	if active_item_id == -1:
		return
	var item = GlobalVars.player_inventory[active_item_id]
	active_item_id = -1
	_start_dialogue(item.on_info())


func _on_drop_pressed() -> void:
	if active_item_id == -1:
		return
	var item = GlobalVars.player_inventory[active_item_id]
	GlobalVars.remove_item_by_id(active_item_id)
	active_item_id = -1
	_start_dialogue(item.on_throw())


func _start_dialogue(dialogue: Array[Dialogue]) -> void:
	visible = false
	var desired_dialogue_offset
	if owner.player_menu_up_offset:
		desired_dialogue_offset = Tools.DIALOGUE_BOTTOM_OFFSET
	else:
		desired_dialogue_offset = Tools.DIALOGUE_TOP_OFFSET
	owner.sub_ui_dialogue = true
	await Tools.start_dialogue(dialogue, null, self, desired_dialogue_offset)
	GlobalVars.close_all_ui.emit()

func _on_update_pos() -> void:
	var ministatsize = $"../MiniStats/PanelContainer".get_combined_minimum_size()
	if ministatsize.x >= 135:
		$PanelContainer.position.x += ministatsize.x - 135
