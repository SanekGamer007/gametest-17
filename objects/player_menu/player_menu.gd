extends CanvasLayer

signal update_text(lvl_data: LevelData)

const PLAYER_MENU_TOP_OFFSET = 0.095
const PLAYER_MENU_BOTTOM_OFFSET = 0.66

var player_menu_desired_offset: float
var player_menu_up_offset: bool
var player_node: Chara = null
var sub_ui_open: bool = false
var sub_ui_dialogue: bool = false
var focus_memory: Button

@onready var level_data: LevelData = get_tree().current_scene.get_node_or_null("LevelData")


func _ready() -> void:
	update_text.emit(level_data)
	if player_node.global_position.y > get_viewport().get_camera_2d().get_screen_center_position().y - 1:
		player_menu_desired_offset = PLAYER_MENU_TOP_OFFSET
		player_menu_up_offset = true
	else:
		player_menu_desired_offset = PLAYER_MENU_BOTTOM_OFFSET
		player_menu_up_offset = false
	$MiniStats/PanelContainer.anchor_top = player_menu_desired_offset
	$MiniStats/PanelContainer.anchor_bottom = player_menu_desired_offset
	GlobalVars.player_start_busy.emit()
	GlobalVars.close_all_ui.connect(_on_ui_quit)
	$Chooser/PanelContainer/HBoxContainer/VBoxContainer/ITEM.grab_focus()


func _input(event: InputEvent) -> void:
	if sub_ui_dialogue:
		return
	if event.is_action_pressed("third_button") or (event.is_action_pressed("second_button") and not sub_ui_open):
		GlobalVars.player_stop_busy.emit()
		get_viewport().set_input_as_handled()
		queue_free()


func _on_ui_quit() -> void:
	queue_free()


func _on_stat_pressed() -> void:
	$Stats.visible = true
	focus_memory = $Chooser/PanelContainer/HBoxContainer/VBoxContainer/STAT
	sub_ui_open = true
	$Stats.grab_focus()


func _on_cell_pressed() -> void:
	$Cell.visible = true
	focus_memory = $Chooser/PanelContainer/HBoxContainer/VBoxContainer/CELL
	sub_ui_open = true
	$Cell.do_focus()


func _on_item_pressed() -> void:
	$Item.visible = true
	focus_memory = $Chooser/PanelContainer/HBoxContainer/VBoxContainer/ITEM
	sub_ui_open = true
	$Item.do_focus()


func _on_debug_pressed() -> void:
	$Debug.visible = true
	focus_memory = $Chooser/PanelContainer/HBoxContainer/VBoxContainer/DEBUG
	sub_ui_open = true
	$Debug.do_focus()


func _on_sub_menu_exit() -> void:
	focus_memory.grab_focus()
	sub_ui_open = false
