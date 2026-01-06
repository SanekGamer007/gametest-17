extends Node

signal disable_menu
signal enable_menu
signal player_start_busy
signal player_stop_busy
signal close_all_ui

enum versions {
	PROTO,
	GAMETEST,
	DEMO,
	RELEASE,
}

var room_name: String = ""
var player_name: String = "CHARA"
var love: int = 0
var gold: int = 0
var player_at: int = 0
var player_df: int = 0
var player_inventory: Dictionary = { }
var flags: Dictionary = { }


func set_flag(flag_name: String, flag_value: Variant):
	flags[flag_name] = flag_value
	print_debug("Flag: ", flag_name, " Been set to ", flag_value)


func get_flag(flag_name: String, default_value: Variant = false) -> Variant:
	if flags.has(flag_name):
		return flags[flag_name]
	else:
		return default_value


func has_flag(flag_name: String) -> bool:
	return flags.has(flag_name)
