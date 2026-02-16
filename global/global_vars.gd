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

enum EquipmentTypes {
	WEAPON,
	ARMOR,
	ANY, # internal only.
}

const MAJOR_GAME_VERSION: int = 0
const MINOR_GAME_VERSION: int = 1
const EMPTY_EQUIP: EquipmentResource = preload("res://items/equipment/None/none.tres")

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
var player_speed: int = 0 # ut hidden stat
var player_base_at: int = 0
var player_base_df: int = 0
var player_base_speed: int = 4 # ut hidden stat
var player_bonus_at: int = 0
var player_bonus_df: int = 0
var player_bonus_speed: int = 0
var player_current_weapon: EquipmentResource = EMPTY_EQUIP
var player_current_armor: EquipmentResource = EMPTY_EQUIP
var player_time: int = 0 #in miliseconds
var player_inventory: Array[ItemResource] = [] # max 8 items
var player_chest: Array[ItemResource] = []
var player_contacts: Array[CellCallResource] = []
var player_kills: int = 0
var player_deaths: int = 0
var player_room: String = "res://levels/test_level.tscn"
var player_room_spawnpoint: String = "A"
var player_room_name: String = ""
var player_serious: bool = false
var player_fun: int = 0
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

func equip_item_force(itemid: int) -> void:
	if player_inventory[itemid] is not EquipmentResource:
		return
	var new_item: EquipmentResource = player_inventory[itemid]
	var old_item: EquipmentResource
	remove_item_by_id(itemid)
	if new_item.type == EquipmentTypes.WEAPON:
		old_item = player_current_weapon
		player_current_weapon = new_item
	elif new_item.type == EquipmentTypes.ARMOR:
		old_item = player_current_armor
		player_current_armor = new_item
	if old_item and old_item != EMPTY_EQUIP:
		add_item(old_item)
	update_vars()


func equip_item(itemid: int) -> Array[Dialogue]:
	if player_inventory[itemid] is not EquipmentResource:
		var dialogue = DialogueText.new()
		dialogue.text = "If you are reading\nthis - i fucked up."
		return [dialogue]
	var new_item: EquipmentResource = player_inventory[itemid]
	var old_item: EquipmentResource
	if new_item.type == EquipmentTypes.WEAPON:
		old_item = player_current_weapon
	elif new_item.type == EquipmentTypes.ARMOR:
		old_item = player_current_armor
	else:
		old_item = player_current_weapon
	if not new_item.is_equipable():
		return new_item.on_fail_equip()
	if not old_item.is_takeofable():
		return old_item.on_fail_takeof()
	equip_item_force(itemid)
	return new_item.on_use_overworld()


func get_current_room() -> String:
	if OS.is_debug_build():
		push_warning("Legacy function call, GlobalVars.get_current_room() instead of Tools.get_current_room(), redirect...")
	return Tools.get_current_room()

#region update vars private shit
func update_vars() -> void:
	_update_love()
	_update_maxhp()
	_update_maxen()
	_update_base_at()
	_update_base_df()
	_update_base_speed()
	_update_bonus_at()
	_update_bonus_df()
	_update_bonus_speed()
	_update_at()
	_update_df()
	_update_speed()
	update_stats.emit()


func _update_maxhp() -> void:
	if player_love <= 19:
		player_maxhp = 16 + (4 * player_love)
	elif player_love == 20: # for some reason in ut lvl 20 gives you 99 hp.
		player_maxhp = 99
	else:
		player_maxhp = 99 + (3 * (player_love - 20))
	player_maxhp += player_current_weapon.get_maxhp_bonus()
	player_maxhp += player_current_armor.get_maxhp_bonus()
	player_hp = min(player_hp, player_maxhp)


func _update_maxen() -> void:
	if player_love <= 19:
		player_maxen = 8 + (2 * player_love)
	elif player_love == 20:
		player_maxen = 49
	else:
		player_maxen = 49 + (1 * (player_love - 20))
	player_maxen += player_current_weapon.get_maxen_bonus()
	player_maxen += player_current_armor.get_maxen_bonus()
	if player_en > player_maxen:
		player_en = player_maxen


func _update_base_at() -> void:
	player_base_at = max(-2 + (2 * player_love), 0)


func _update_base_df() -> void:
	player_base_df = max((player_love - 1) / 4, 0)


func _update_base_speed() -> void:
	player_base_speed = 4 # ultra placeholder.


func _update_bonus_at() -> void:
	player_bonus_at = player_current_weapon.get_atk_bonus()
	player_bonus_at += player_current_armor.get_atk_bonus()


func _update_bonus_df() -> void:
	player_bonus_df = player_current_armor.get_df_bonus()
	player_bonus_df += player_current_weapon.get_df_bonus()


func _update_bonus_speed() -> void:
	player_speed = player_current_weapon.get_spd_bonus()
	player_speed += player_current_armor.get_spd_bonus()


func _update_at() -> void:
	player_at = player_base_at + player_bonus_at


func _update_df() -> void:
	player_df = player_base_df + player_bonus_df


func _update_speed() -> void:
	player_speed = player_base_speed + player_bonus_speed


func _update_love() -> void:
	player_love = get_level_from_exp(player_exp)

#endregion

func get_required_exp(lv: int) -> int:
	if lv <= 20:
		return exp_table[lv - 1]
	elif lv >= 99:
		return 125000
	return snapped(int(12.5 * pow(lv, 3) + 50 * lv), 5000)


func get_level_from_exp(experience: int) -> int:
	for i in range(99, 0, -1):
		if experience >= get_required_exp(i):
			return i
	return 1
