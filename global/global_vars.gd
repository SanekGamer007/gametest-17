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
	ANY,
}

const MAJOR_GAME_VERSION: int = 0
const MINOR_GAME_VERSION: int = 1

# save vars
var player_name: String = ""
var player_hp: int = 20
var player_maxhp: int = 20
var player_love: int = 1
var player_gold: int = 0
var player_at: int = 0
var player_df: int = 0
var player_time: int = 0 #in miliseconds
var player_inventory: Array = [null] # max 10 items
var player_room: String = "res://levels/test_level.tscn"
var player_room_spawnpoint: String = "A"
var player_room_name: String = ""
var flags: Dictionary = { }
var load_time: int = 0 # time at which a save file was loaded.

# persistent vars
var checksum_fail: int = 0
var has_beaten_demo: bool = false
var true_reset_count: int = 0

#region flag stuff

func set_flag(flag_name: String, flag_value: Variant):
	GlobalVars.flags[flag_name] = flag_value
	print_debug("Flag: ", flag_name, " has been set to \"", flag_value, "\"")


func get_flag(flag_name: String, default_value: Variant = false) -> Variant:
	if GlobalVars.flags.has(flag_name):
		return GlobalVars.flags[flag_name]
	else:
		return default_value


func has_flag(flag_name: String) -> bool:
	return GlobalVars.flags.has(flag_name)

#endregion
