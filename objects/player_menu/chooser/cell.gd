extends "res://objects/player_menu/chooser/button_icon.gd"

func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData) -> void:
	if GlobalVars.player_contacts.size() == 0:
		visible = false
