extends "res://debug/debug_menu/blah/button_icon.gd"

var toggle: bool = false


func _on_pressed() -> void:
	if !toggle:
		GlobalVars.player_hp = 2147483647
		toggle = true
		text = "INF HP (%s)" % "ON"
	else:
		GlobalVars.player_hp = GlobalVars.player_maxhp
		toggle = false
		text = "INF HP (%s)" % "OFF"
