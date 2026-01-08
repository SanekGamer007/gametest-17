extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Save/Info/NAME.text = GlobalVars.player_name
	$Save/Info/LV.text = "LV %s" % GlobalVars.player_love
	$Save/Info/TIME.text = Tools.time_to_string(GlobalVars.player_time)
	$Save/ROOM.text = GlobalVars.room_name

	$Save/Buttons/HBoxContainer/Continue.grab_focus()
