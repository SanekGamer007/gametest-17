extends Node

signal disable_menu
signal enable_menu
signal player_start_busy
signal player_stop_busy
signal close_all_ui
signal update_stats

enum Versions {
	PROTO,
	GAMETEST,
	DEMO,
	RELEASE,
	ANY,
}

const MAJOR_GAME_VERSION: int = 0
const MINOR_GAME_VERSION: int = 1

# player vars
var player_name: String = ""
var player_hp: int = 20
var player_maxhp: int = 20
var player_en: int = 10
var player_maxen: int = 10
var player_love: int = 1
var player_exp: int = 0
var player_gold: int = 0
var player_at: int = 0 # calculate at runtime! do not save
var player_df: int = 0 # calculate at runtime! do not save
var player_base_at: int = 0
var player_base_df: int = 0
var player_current_weapon: ItemResource # change to equipment resource later.
var player_current_armor: ItemResource # change to equipment resource later.
var player_time: int = 0 #in miliseconds
var player_inventory: Array[ItemResource] # max 10 items
var player_contacts: Array[CellCallResource]
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
	return default_value


func has_flag(flag_name: String) -> bool:
	return GlobalVars.flags.has(flag_name)

#endregion

func heal_player(amount: int) -> void:
	player_hp = min(player_hp + amount, player_maxhp)


func add_item(item: ItemResource) -> bool:
	if player_inventory.size() >= 10:
		return false
	else:
		player_inventory.append(item)
		return true


func remove_item(idx: int) -> void:
	if idx >= 0 and idx < player_inventory.size():
		player_inventory.remove_at(idx)
	else:
		push_error(idx, " - Index out of bounds.")
