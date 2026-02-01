extends ItemResource

class_name EquipmentResource

@export var atk: int = 0
@export var df: int = 0
@export var spd: int = 0
@export var maxen: int = 0
@export var maxhp: int = 0
@export var type: GlobalVars.EquipmentTypes = GlobalVars.EquipmentTypes.WEAPON
@export var equip_text_ow: Array[Dialogue]
@export var equip_text_bt: Array[Dialogue]
@export var fail_equip: Array[Dialogue]
@export var fail_takeof: Array[Dialogue]


func on_use_overworld() -> Array[Dialogue]:
	return equip_text_ow


func on_use_battle() -> Array[Dialogue]:
	return equip_text_bt


func on_fail_equip() -> Array[Dialogue]:
	return fail_equip


func on_fail_takeof() -> Array[Dialogue]:
	return fail_takeof


func get_atk_bonus() -> int:
	return atk


func get_df_bonus() -> int:
	return df


func get_spd_bonus() -> int:
	return spd


func get_maxhp_bonus() -> int:
	return maxhp


func get_maxen_bonus() -> int:
	return maxen


func get_equip_type() -> GlobalVars.EquipmentTypes:
	return type


func is_equipable() -> bool:
	return true


func is_takeofable() -> bool:
	return true
