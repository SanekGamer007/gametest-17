extends Node

const SAVE_FILE_LOCATON = "user://file0"
const SAVE_HEADER = [0x47, 0x54, 0x31, 0x37] # GT17

var libsecret = GameSecrets.new()


func _ready() -> void:
	load_game()


func save_game() -> bool:
	var savebytes: PackedByteArray = _get_header_with_version()
	var save_variables: Dictionary = {
		"player_name": GlobalVars.player_name,
		"player_hp": GlobalVars.player_hp,
		"player_maxhp": GlobalVars.player_maxhp,
		"player_love": GlobalVars.player_love,
		"player_gold": GlobalVars.player_gold,
		"player_at": GlobalVars.player_at,
		"player_df": GlobalVars.player_df,
		"player_time": GlobalVars.player_time,
		"player_inventory": GlobalVars.player_inventory,
		"player_room_uid": GlobalVars.player_room_uid,
		"player_room_spawnpoint": GlobalVars.player_room_spawnpoint,
		"player_room_name": GlobalVars.player_room_name,
		"checksum_fail": GlobalVars.checksum_fail,
	}
	var data_dict: Dictionary = {
		"vars": save_variables,
		"flags": GlobalVars.flags,
	}
	var data = var_to_bytes(data_dict)
	savebytes.append_array(data)
	savebytes.append_array(_get_sha256(data))
	savebytes.append_array(_generate_random_bytes(64))

	savebytes.append_array(_get_sha256(savebytes))

	var file = FileAccess.open_encrypted(SAVE_FILE_LOCATON, FileAccess.WRITE, libsecret.get_save_key())

	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the save file. Error code: %d" % err)
		return false

	file.store_buffer(savebytes)
	file.close()

	return true


func load_game() -> bool:
	var increase_naughty: bool = false

	if not FileAccess.file_exists(SAVE_FILE_LOCATON):
		push_warning("Save file not found.")
		return false

	var file = FileAccess.open_encrypted(SAVE_FILE_LOCATON, FileAccess.READ, libsecret.get_save_key())

	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the save file. Error code: %d" % err)
		return false

	var filebytes = file.get_buffer(file.get_length())
	var save_checksum: PackedByteArray = filebytes.slice(-32)
	file.close()

	var header: PackedByteArray = filebytes.slice(0, 4)
	if not header.get_string_from_utf8() == "GT17":
		push_error(header.get_string_from_utf8(), "is an Invalid header.")
		return false
	var save_version: Array
	save_version = filebytes.slice(4, 6)

	if save_version != [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION]:
		if save_version[0] <= GlobalVars.MAJOR_GAME_VERSION or save_version[1] <= GlobalVars.MINOR_GAME_VERSION:
			push_error("Save file is made for an older version of the game, migration is currently not supported.")
		else:
			push_error("Save file is made for an newer version of the game.")
		return false

	if _get_sha256(filebytes.slice(0, -32)) != save_checksum:
		increase_naughty = true # save file may have been modified.

	var savebytes: PackedByteArray = filebytes.slice(6, -96)
	var save_dict_bytes: PackedByteArray = savebytes.slice(0, -32)
	var save_dict_hash: PackedByteArray = savebytes.slice(-32)

	if _get_sha256(save_dict_bytes) != save_dict_hash:
		increase_naughty = true

	var save_dict: Dictionary = bytes_to_var(save_dict_bytes)

	var save_vars: Dictionary = save_dict.get("vars")
	var save_flags: Dictionary = save_dict.get("flags")
	if save_vars == null or save_flags == null:
		push_error("Save file is corrupted.")
		return false

	for variable in save_vars:
		if variable in GlobalVars:
			var current_val = GlobalVars.get(variable)
			var save_val = save_vars.get(variable)

			if typeof(current_val) != typeof(save_val):
				push_error("Invalid property type. Save file corrupted or modified?")
			else:
				GlobalVars.set(variable, save_vars.get(variable))

	for flag in save_flags:
		GlobalVars.set_flag(flag, save_flags.get(flag))

	if increase_naughty:
		print("naughty")
		GlobalVars.checksum_fail += 1
		if GlobalVars.checksum_fail >= 3:
			return true
		else:
			save_game()
	return true


func _get_header_with_version() -> PackedByteArray:
	var header: PackedByteArray = PackedByteArray(SAVE_HEADER)
	header.append(GlobalVars.MAJOR_GAME_VERSION)
	header.append(GlobalVars.MINOR_GAME_VERSION)
	return header


func _get_sha256(data: PackedByteArray) -> PackedByteArray:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(data)
	return ctx.finish()


func _generate_random_bytes(size: int) -> PackedByteArray:
	var cryptogen = Crypto.new()
	return cryptogen.generate_random_bytes(size)
