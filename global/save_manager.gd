extends Node

const SAVE_FILE_LOCATION = "user://file0"
const SYS_INFO_LOCATION = "user://system_information"
const SAVE_HEADER = [0x47, 0x54, 0x31, 0x37] # GT17

var libsecret = GameSecrets.new()

#region Save Game logic
func save_game() -> bool:
	print("Starting saving")
	var session_time: int = Time.get_ticks_msec() - GlobalVars.load_time
	var play_time: int = GlobalVars.player_time + session_time

	var savebytes: PackedByteArray = _get_header_with_version()
	var save_variables: Dictionary = {
		"player_name": GlobalVars.player_name,
		"player_hp": GlobalVars.player_hp,
		"player_en": GlobalVars.player_en,
		"player_exp": GlobalVars.player_exp,
		"player_gold": GlobalVars.player_gold,
		"player_base_at": GlobalVars.player_base_at,
		"player_base_df": GlobalVars.player_base_df,
		"player_base_speed": GlobalVars.player_base_speed,
		"player_current_weapon": GlobalVars.player_current_weapon,
		"player_current_armor": GlobalVars.player_current_armor,
		"player_time": play_time,
		"player_inventory": GlobalVars.player_inventory,
		"player_chest": GlobalVars.player_chest,
		"player_contacts": GlobalVars.player_contacts,
		"player_kills": GlobalVars.player_kills,
		"player_room": GlobalVars.player_room,
		"player_room_spawnpoint": GlobalVars.player_room_spawnpoint,
		"player_serious": GlobalVars.player_serious,
		"player_fun": GlobalVars.player_fun,
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

	var file

	if OS.is_debug_build():
		file = FileAccess.open(SAVE_FILE_LOCATION + ".debug", FileAccess.WRITE)
		file.store_string(var_to_str(data_dict))
		file.close()
		print("debug saved")
	else:
		file = FileAccess.open_encrypted(SAVE_FILE_LOCATION, FileAccess.WRITE, libsecret.get_save_key())
		if file == null:
			var err = FileAccess.get_open_error()
			push_error("Unable to open the save file. Error code: %d" % err)
			return false
		file.store_buffer(savebytes)
		file.close()

	print("Done saving!")

	GlobalVars.load_time = Time.get_ticks_msec()
	GlobalVars.player_time = play_time

	return true


func load_game() -> Dictionary:
	var increase_naughty: bool = false

	if OS.is_debug_build(): # debug code
		if not FileAccess.file_exists(SAVE_FILE_LOCATION + ".debug"):
			push_warning("Save file not found.")
			return { }
		var save_data = FileAccess.get_file_as_string(SAVE_FILE_LOCATION + ".debug")
		var data = str_to_var(save_data)
		return data

	if not FileAccess.file_exists(SAVE_FILE_LOCATION):
		push_warning("Save file not found.")
		return { }

	var file = FileAccess.open_encrypted(SAVE_FILE_LOCATION, FileAccess.READ, libsecret.get_save_key())

	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the save file. Error code: %d" % err)
		return { }

	var filebytes = file.get_buffer(file.get_length())
	var save_checksum: PackedByteArray = filebytes.slice(-32)
	file.close()

	var header: PackedByteArray = filebytes.slice(0, 4)
	if not header.get_string_from_utf8() == "GT17":
		push_error("The save file contains an invalid header.")
		return { }
	var save_version: Array
	save_version = filebytes.slice(4, 6)

	if save_version != [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION]:
		if save_version[0] <= GlobalVars.MAJOR_GAME_VERSION or save_version[1] <= GlobalVars.MINOR_GAME_VERSION:
			push_error("Save file is made for an older version of the game, migration is currently not supported.")
		else:
			push_error("Save file is made for an newer version of the game.")
		return { }

	if _get_sha256(filebytes.slice(0, -32)) != save_checksum:
		increase_naughty = true # save file may have been modified.

	var savebytes: PackedByteArray = filebytes.slice(6, -96)
	var save_dict_bytes: PackedByteArray = savebytes.slice(0, -32)
	var save_dict_hash: PackedByteArray = savebytes.slice(-32)

	if _get_sha256(save_dict_bytes) != save_dict_hash:
		increase_naughty = true

	var save_dict: Dictionary = bytes_to_var(save_dict_bytes)

	if save_dict.get("vars") == null or save_dict.get("flags") == null:
		push_error("Save file is corrupted.")
		return { }

	if increase_naughty:
		GlobalVars.checksum_fail += 1
	#	if GlobalVars.checksum_fail < 3:
	#		save_game()
	return save_dict


func load_save_to_global(save_dict: Dictionary) -> bool:
	if save_dict == null or save_dict == { }:
		if OS.is_debug_build():
			push_error("save_dict is invalid.")
		else:
			push_error("Save file is corrupted.")
		return false

	var save_vars = save_dict.get("vars")
	var save_flags = save_dict.get("flags")

	for variable in save_vars:
		if variable in GlobalVars:
			var current_val = GlobalVars.get(variable)
			var save_val = save_vars.get(variable)

			if typeof(current_val) != typeof(save_val):
				if OS.is_debug_build():
					push_error(save_val, " is an invalid property type. Save file corrupted or modified?")
			else:
				GlobalVars.set(variable, save_vars.get(variable))

	for flag in save_flags:
		GlobalVars.set_flag(flag, save_flags.get(flag))
	return true


func save_file_exists() -> bool:
	if OS.is_debug_build():
		return FileAccess.file_exists(SAVE_FILE_LOCATION + ".debug")
	return FileAccess.file_exists(SAVE_FILE_LOCATION)
#endregion

#region System Information Save Logic
func save_system_information() -> bool:
	print("Starting saving sys info")

	var savebytes: PackedByteArray = _get_header_with_version()
	var data_dict: Dictionary = {
		"checksum_fail": GlobalVars.checksum_fail,
		"has_beaten_demo": GlobalVars.has_beaten_demo,
		"true_reset_count": GlobalVars.true_reset_count,
	}
	var data = var_to_bytes(data_dict)
	savebytes.append_array(data)
	savebytes.append_array(_get_sha256(data))
	savebytes.append_array(_generate_random_bytes(64))

	savebytes.append_array(_get_sha256(savebytes))

	var file

	if OS.is_debug_build():
		file = FileAccess.open(SYS_INFO_LOCATION + ".debug", FileAccess.WRITE)
		file.store_string(var_to_str(data_dict))
		file.close()
		print("debug sys info saved")

	else:
		file = FileAccess.open_encrypted(SYS_INFO_LOCATION, FileAccess.WRITE, libsecret.get_save_key())
		if file == null:
			var err = FileAccess.get_open_error()
			push_error("Unable to open the sys info file. Error code: %d" % err)
			return false
		file.store_buffer(savebytes)
		file.close()
		print("Done saving sys info!")

	return true


func load_system_information() -> Dictionary:
	var increase_naughty: bool = false

	if OS.is_debug_build(): # debug code
		if not FileAccess.file_exists(SYS_INFO_LOCATION + ".debug"):
			push_warning("sys info file not found.")
			return { }
		var sys_data = FileAccess.get_file_as_string(SYS_INFO_LOCATION + ".debug")
		var data = str_to_var(sys_data)
		return data

	if not FileAccess.file_exists(SYS_INFO_LOCATION):
		push_warning("sys info file not found.")
		return { }

	var file = FileAccess.open_encrypted(SYS_INFO_LOCATION, FileAccess.READ, libsecret.get_save_key())

	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the sys info file. Error code: %d" % err)
		return { }

	var filebytes = file.get_buffer(file.get_length())
	var sys_checksum: PackedByteArray = filebytes.slice(-32)
	file.close()

	var header: PackedByteArray = filebytes.slice(0, 4)
	if not header.get_string_from_utf8() == "GT17":
		push_error("The sys info file contains an invalid header.")
		return { }
	var sys_version: Array
	sys_version = filebytes.slice(4, 6)

	if sys_version != [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION]:
		if sys_version[0] <= GlobalVars.MAJOR_GAME_VERSION or sys_version[1] <= GlobalVars.MINOR_GAME_VERSION:
			push_error("sys file is made for an older version of the game, migration is currently not supported.")
		else:
			push_error("sys file is made for an newer version of the game.")
		return { }

	if _get_sha256(filebytes.slice(0, -32)) != sys_checksum:
		increase_naughty = true # sys file may have been modified.

	var savebytes: PackedByteArray = filebytes.slice(6, -96)
	var sys_dict_bytes: PackedByteArray = savebytes.slice(0, -32)
	var sys_dict_hash: PackedByteArray = savebytes.slice(-32)

	if _get_sha256(sys_dict_bytes) != sys_dict_hash:
		increase_naughty = true

	var sys_dict: Dictionary = bytes_to_var(sys_dict_bytes)

	if sys_dict.size() == 0:
		push_error("Sys file is corrupted.")
		return { }

	if increase_naughty:
		GlobalVars.checksum_fail += 1
	#	if GlobalVars.checksum_fail < 3:
	#		save_game()
	return sys_dict


func load_sys_info_to_global(sys_dict: Dictionary) -> bool:
	if sys_dict == null or sys_dict == { }:
		if OS.is_debug_build():
			push_error("sys_dict is invalid.")
		else:
			push_error("Sys file is corrupted.")
		return false

	for variable in sys_dict:
		if variable in GlobalVars:
			var current_val = GlobalVars.get(variable)
			var save_val = sys_dict.get(variable)

			if typeof(current_val) != typeof(save_val):
				push_error("Invalid property type. Sys file corrupted or modified?")
			else:
				GlobalVars.set(variable, sys_dict.get(variable))

	return true


func sys_file_exists() -> bool:
	if OS.is_debug_build():
		return FileAccess.file_exists(SYS_INFO_LOCATION + ".debug")
	return FileAccess.file_exists(SYS_INFO_LOCATION)
#endregion

#region Private functions
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
#endregion
