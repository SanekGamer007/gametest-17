extends Node

const SAVE_FILE_LOCATION = "user://file"
const SAVE_SUFFIX = ["0" ,"4", "5", "6"]
const SYS_INFO_LOCATION = "user://system_information"
const SAVE_HEADER = [0x47, 0x54, 0x31, 0x37] # GT17

var libsecret = GameSecrets.new()

#region Save Game logic
func save_game() -> bool:
	var save_variables: Dictionary = {
		"player_name": GlobalVars.player_name,
		"player_hp": GlobalVars.player_hp,
		"player_en": GlobalVars.player_en,
		"player_exp": GlobalVars.player_exp,
		"player_gold": GlobalVars.player_gold,
		"player_base_at": GlobalVars.player_base_at,
		"player_base_df": GlobalVars.player_base_df,
		"player_base_speed": GlobalVars.player_base_speed,
		"player_current_weapon": GlobalVars.player_current_weapon.resource_path,
		"player_current_armor": GlobalVars.player_current_armor.resource_path,
		"player_inventory": GlobalVars.player_inventory.map(func(item): return item.resource_path),
		"player_chest": GlobalVars.player_chest.map(func(item): return item.resource_path),
		"player_contacts": GlobalVars.player_contacts.map(func(caller): return caller.resource_path),
		"player_spells": GlobalVars.player_spells.map(func(spell): return spell.resource_path),
		"player_time": 0,
		"player_kills": GlobalVars.player_kills,
		"player_deaths": GlobalVars.player_deaths,
		"player_room": GlobalVars.player_room,
		"player_room_spawnpoint": GlobalVars.player_room_spawnpoint,
		"player_serious": GlobalVars.player_serious,
		"player_fun": GlobalVars.player_fun,
	}
	print("Starting saving")
	var session_time: int = Time.get_ticks_msec() - GlobalVars.load_time
	var play_time: int = GlobalVars.player_time + session_time

	save_variables.set("player_time", play_time)
	var data_dict: Dictionary = {
		"vars": save_variables,
		"flags": GlobalVars.flags,
	}
	if OS.is_debug_build(): # remove later
		for i in range(SAVE_SUFFIX.size() - 1, 0, -1):
			var target = SAVE_FILE_LOCATION + SAVE_SUFFIX[i] + ".debug"
			var source = SAVE_FILE_LOCATION + SAVE_SUFFIX[i-1] + ".debug"
			if FileAccess.file_exists(target):
				DirAccess.remove_absolute(target)
			if FileAccess.file_exists(source):
				DirAccess.copy_absolute(source, target)
	else:
		for i in range(SAVE_SUFFIX.size() - 1):
			var target = SAVE_FILE_LOCATION + SAVE_SUFFIX[i+1]
			var source = SAVE_FILE_LOCATION + SAVE_SUFFIX[i]
			if FileAccess.file_exists(target):
				DirAccess.remove_absolute(target)
			if FileAccess.file_exists(source):
				DirAccess.copy_absolute(source, target)
	if _save(data_dict, false) == false:
		return false

	GlobalVars.load_time = Time.get_ticks_msec()
	GlobalVars.player_time = play_time

	return true


func load_game() -> Dictionary:
	var increase_naughty: bool = false
	if OS.is_debug_build(): # debug code
		if not save_file_exists():
			push_warning("Save file not found.")
			return { }
		var file = null
		for i in SAVE_SUFFIX:
			var tmpfile = FileAccess.get_file_as_string(SAVE_FILE_LOCATION + i + ".debug")
			if tmpfile == null or tmpfile == "":
				continue
			else:
				file = tmpfile
				break
		var save_data = str_to_var(file)
		var save_vars: Dictionary = save_data.get("vars")

		var loaded_inventory: Array[ItemResource]
		var loaded_chest: Array[ItemResource]
		var loaded_phone: Array[CellCallResource]
		
		for i in save_vars:
			if i == "player_current_weapon":
				if ResourceLoader.exists(save_vars.get(i)):
					save_vars["player_current_weapon"] = load(save_vars.get("player_current_weapon"))
				else:
					save_vars["player_current_weapon"] = GlobalVars.EMPTY_EQUIP
				continue
			if i == "player_current_armor":
				if ResourceLoader.exists(save_vars.get(i)):
					save_vars["player_current_armor"] = load(save_vars.get("player_current_armor"))
				else:
					save_vars["player_current_weapon"] = GlobalVars.EMPTY_EQUIP
				continue
			if i == "player_inventory":
				for res in save_vars.get("player_inventory"):
					loaded_inventory.append(_convert_resources(res))
				continue
			if i == "player_chest":
				for res in save_vars.get("player_chest"):
					loaded_chest.append(_convert_resources(res))
				continue
			if i == "player_contacts":
				for res in save_vars.get("player_contacts"):
					loaded_phone.append(_convert_resources(res))
				continue

		save_vars["player_inventory"] = loaded_inventory
		save_vars["player_chest"] = loaded_chest
		save_vars["player_contacts"] = loaded_phone

		save_data["vars"] = save_vars
		return save_data

	if not save_file_exists():
		push_warning("Save file not found.")
		return { }
	
	var file = null
	for i in SAVE_SUFFIX:
		var tmpfile = FileAccess.open_encrypted(SAVE_FILE_LOCATION + i, FileAccess.READ, libsecret.get_save_key())
		if tmpfile == null or tmpfile == "":
			continue
		else:
			file = tmpfile
			break
	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the save file. Error code: %d" % err)
		return { }
	
	var filesize = file.get_length()
	if filesize < 134 or filesize > 1024 * 100: # less than 134 bytes or more than 100 kb
		if OS.is_debug_build():
			push_error("Save file size is invalid.")
		else:
			push_error("Save file is corrupted.")
		return { }
	var filebytes = file.get_buffer(file.get_length())
	var save_checksum: PackedByteArray = filebytes.slice(-32)
	file.close()

	var header: PackedByteArray = filebytes.slice(0, 4)
	if not header.get_string_from_utf8() == "GT17":
		if OS.is_debug_build():
			push_error("The save file contains an invalid header.")
		else:
			push_error("Save file is corrupted.")
		return { }
	var save_version: Array
	save_version = filebytes.slice(4, 6)

	if save_version != [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION]:
		var gamever = (GlobalVars.MAJOR_GAME_VERSION * 1000) + GlobalVars.MINOR_GAME_VERSION
		var savever = (save_version[0] * 1000) + save_version[1]
		if savever > gamever:
			push_error("Save file is made for an newer version of the game.")
		else:
			push_error("Save file is made for an older version of the game, migration is currently not supported.")
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

	var save_vars = save_dict.get("vars")


	var loaded_inventory: Array[ItemResource]
	var loaded_chest: Array[ItemResource]
	var loaded_phone: Array[CellCallResource]
	
	for i in save_vars:
		if i == "player_current_weapon":
			if ResourceLoader.exists(save_vars.get(i)):
				save_vars["player_current_weapon"] = load(save_vars.get("player_current_weapon"))
			else:
				save_vars["player_current_weapon"] = GlobalVars.EMPTY_EQUIP
			continue
		if i == "player_current_armor":
			if ResourceLoader.exists(save_vars.get(i)):
				save_vars["player_current_armor"] = load(save_vars.get("player_current_armor"))
			else:
				save_vars["player_current_weapon"] = GlobalVars.EMPTY_EQUIP
			continue
		if i == "player_inventory":
			for res in save_vars.get("player_inventory"):
				loaded_inventory.append(_convert_resources(res))
			continue
		if i == "player_chest":
			for res in save_vars.get("player_chest"):
				loaded_chest.append(_convert_resources(res))
			continue
		if i == "player_contacts":
			for res in save_vars.get("player_contacts"):
				loaded_phone.append(_convert_resources(res))
			continue

	save_vars["player_inventory"] = loaded_inventory
	save_vars["player_chest"] = loaded_chest
	save_vars["player_contacts"] = loaded_phone

	save_dict["vars"] = save_vars


	if increase_naughty:
		print_debug("Naughty naughty detected.")
		GlobalVars.checksum_fail += 1
		save_system_information()
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
	var check: bool = false
	if OS.is_debug_build():
		for i in SAVE_SUFFIX:
			var tmp = FileAccess.file_exists(SAVE_FILE_LOCATION + i + ".debug")
			print(tmp)
			if tmp == null or tmp == false:
				continue
			else:
				check = tmp
				break
		return check
	for i in SAVE_SUFFIX:
		var tmp = FileAccess.file_exists(SAVE_FILE_LOCATION + i)
		if tmp == null or tmp == false:
			continue
		else:
			check = tmp
			break
	return check
#endregion

#region System Information Save Logic
func save_system_information() -> bool:
	var data_dict: Dictionary = {
		"checksum_fail": GlobalVars.checksum_fail,
		"has_beaten_demo": GlobalVars.has_beaten_demo,
		"true_reset_count": GlobalVars.true_reset_count,
	}
	return _save(data_dict, true)


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
		push_warning("Save file not found.")
		return { }

	var file = FileAccess.open_encrypted(SYS_INFO_LOCATION, FileAccess.READ, libsecret.get_save_key())

	if file == null:
		var err = FileAccess.get_open_error()
		push_error("Unable to open the save file. Error code: %d" % err)
		return { }

	var filebytes = file.get_buffer(file.get_length())
	var sys_checksum: PackedByteArray = filebytes.slice(-32)
	file.close()

	var header: PackedByteArray = filebytes.slice(0, 4)
	if not header.get_string_from_utf8() == "GT17":
		if OS.is_debug_build():
			push_error("The sys file contains an invalid header.")
		else:
			push_error("Save file is corrupted.")
		return { }
	var sys_version: Array
	sys_version = filebytes.slice(4, 6)

	if sys_version != [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION]:
		var gamever = (GlobalVars.MAJOR_GAME_VERSION * 1000) + GlobalVars.MINOR_GAME_VERSION
		var sysver = (sys_version[0] * 1000) + sys_version[1]
		if sysver > gamever:
			push_error("Save file is made for an newer version of the game.")
		else:
			push_error("Save file is made for an older version of the game, migration is currently not supported.")
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
		push_error("Save file is corrupted.")
		return { }

	if increase_naughty:
		GlobalVars.checksum_fail += 1
	return sys_dict


func load_sys_info_to_global(sys_dict: Dictionary) -> bool:
	if sys_dict == null or sys_dict == { }:
		if OS.is_debug_build():
			push_error("sys_dict is invalid.")
		else:
			push_error("Save file is corrupted.")
		return false

	for variable in sys_dict:
		if variable in GlobalVars:
			var current_val = GlobalVars.get(variable)
			var save_val = sys_dict.get(variable)

			if typeof(current_val) != typeof(save_val):
				print_debug("Invalid property type. Save file corrupted or modified?")
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


func _convert_resources(res: String) -> Resource:
	var result
	if ResourceLoader.exists(res):
		result = load(res)
	return result
	
func _save(data_dict: Dictionary, is_sys_info: bool) -> bool:
	var bytes: PackedByteArray = _get_header_with_version()
	var data = var_to_bytes(data_dict)
	bytes.append_array(data)
	bytes.append_array(_get_sha256(data))
	bytes.append_array(_generate_random_bytes(64))

	bytes.append_array(_get_sha256(bytes))
	var file

	if OS.is_debug_build():
		if not is_sys_info:
			file = FileAccess.open(SAVE_FILE_LOCATION + SAVE_SUFFIX[0] + ".debug", FileAccess.WRITE)
		else:
			file = FileAccess.open(SYS_INFO_LOCATION + ".debug", FileAccess.WRITE)
		file.store_string(var_to_str(data_dict))
		file.close()
		print_debug("debug saved")
	else:
		if not is_sys_info:
			file = FileAccess.open_encrypted(SAVE_FILE_LOCATION + SAVE_SUFFIX[0], FileAccess.WRITE, libsecret.get_save_key())
		else:
			file = FileAccess.open_encrypted(SYS_INFO_LOCATION + ".debug", FileAccess.WRITE, libsecret.get_save_key())
		if file == null:
			var err = FileAccess.get_open_error()
			push_error("Unable to open the save file. Error code: %d" % err)
			return false
		file.store_buffer(bytes)
		file.close()
	var stringy: String = "sys_file" if is_sys_info else "save_file"
	print_debug("Done saving " + stringy + "!")
	return true


#endregion
