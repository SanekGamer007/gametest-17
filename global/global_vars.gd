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
var player_maxhp: int
var player_en: int = 10
var player_maxen: int
var player_love: int = 1
var player_exp: int = 0
var player_gold: int = 0
var player_at: int = 0 # calculate at runtime! do not save
var player_df: int = 0 # calculate at runtime! do not save
var player_speed: int = 0 # ut hidden stat
var player_base_at: int = 0
var player_base_df: int = 0
var player_base_speed: int = 4 # ut hidden stat
var player_current_weapon: ItemResource # change to equipment resource later.
var player_current_armor: ItemResource # change to equipment resource later.
var player_time: int = 0 #in miliseconds
var player_inventory: Array[ItemResource] # max 8 items
var player_contacts: Array[CellCallResource]
var player_kills: int = 0
var player_room: String = "res://levels/test_level.tscn"
var player_room_spawnpoint: String = "A"
var player_room_name: String = ""
var player_serious: bool = false
var flags: Dictionary = { }
var load_time: int = 0 # time at which a save file was loaded.

# persistent vars
var checksum_fail: int = 0
var has_beaten_demo: bool = false
var true_reset_count: int = 0

const exp_table: Array[int] = [
	0,
	10,
	30,
	70,
	120,
	200,
	300,
	500,
	800,
	1200,
	1700,
	2500,
	3500,
	5000,
	7000,
	10000,
	15000,
	25000,
	50000,
	99999,
]

#region flag stuff

func set_flag(flag_name: String, flag_value: Variant):
	flags[flag_name] = flag_value
	print_debug("Flag: ", flag_name, " has been set to \"", flag_value, "\"")


func get_flag(flag_name: String, default_value: Variant = false) -> Variant:
	if flags.has(flag_name):
		return flags[flag_name]
	return default_value


func has_flag(flag_name: String) -> bool:
	return flags.has(flag_name)

#endregion

#region item stuff
func add_item(item: ItemResource) -> bool:
	if player_inventory.size() >= 8:
		return false
	else:
		player_inventory.append(item)
		return true


func remove_item_by_id(idx: int) -> void:
	if idx >= 0 and idx < player_inventory.size():
		player_inventory.remove_at(idx)
	else:
		if OS.is_debug_build():
			push_error(idx, " - Index out of bounds.")


func remove_item_by_resource(item: ItemResource) -> void:
	if player_inventory.has(item):
		var idx: int = player_inventory.find(item)
		player_inventory.remove_at(idx)
	else:
		if OS.is_debug_build():
			push_error("Item does not exist.")

#endregion

#region contact stuff

func add_contact(contact: CellCallResource) -> bool:
	if not player_contacts.has(contact):
		player_contacts.append(contact)
		return true
	else:
		if OS.is_debug_build():
			push_warning("Contact already added.")
		return false


func remove_contact(contact: CellCallResource) -> void:
	if player_contacts.has(contact):
		var idx: int = player_contacts.find(contact)
		player_contacts.remove_at(idx)
	else:
		if OS.is_debug_build():
			push_error("Contact does not exist.")

#endregion

func heal_player(amount: int) -> void:
	player_hp = min(player_hp + amount, player_maxhp)


func get_current_room() -> String:
	if player_room.begins_with("res://"):
		return player_room

	if ResourceUID.ensure_path(player_room):
		return ResourceUID.get_id_path(ResourceUID.text_to_id(player_room))
	else:
		if OS.is_debug_build():
			push_error("Invalid player room.")
		return ""


func update_vars() -> void:
	_update_love()
	_update_maxhp()
	_update_maxen()
	_update_base_at()
	_update_base_df()
	_update_at()
	_update_df()
	update_stats.emit()


func _update_maxhp() -> void:
	if player_love <= 19:
		player_maxhp = 16 + (4 * player_love)
	elif player_love == 20: # for some reason in ut lvl 20 gives you 99 hp.
		player_maxhp = 99
	else:
		player_maxhp = 99 + (2 * (player_love - 20))


func _update_maxen() -> void:
	if player_love <= 19:
		player_maxen = 8 + (2 * player_love)
	elif player_love == 20:
		player_maxen = 49
	else:
		player_maxen = 49 + (1 * (player_love - 20))


func _update_base_at() -> void:
	player_base_at = max(-2 + (2 * player_love), 0)


func _update_base_df() -> void:
	player_base_df = max((player_love - 1) / 4, 0)


func _update_at() -> void:
	player_at = player_base_at # placeholder until equipment is implemented


func _update_df() -> void:
	player_df = player_base_df # placeholder until equipment is implemented


func _update_love() -> void:
	player_love = get_level_from_exp(player_exp)


func get_required_exp(lv: int) -> int:
	if lv <= 20:
		return exp_table[lv - 1]
	return snapped(int(12.5 * pow(lv, 3) + 50 * lv), 5000)


func get_level_from_exp(experience: int) -> int:
	for i in range(99, 0, -1):
		if experience >= get_required_exp(i):
			return i
	return 1
