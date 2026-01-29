extends "res://debug/debug_menu/blah/button_icon.gd"

var toggle: bool = false


func _on_pressed() -> void:
	if !toggle:
		GlobalVars.player_en = 2147483647
		toggle = true
		text = "INF EN (%s)" % "ON"
	else:
		GlobalVars.player_en = GlobalVars.player_maxen
		toggle = false
		text = "INF EN (%s)" % "OFF"
