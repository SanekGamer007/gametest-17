extends Node

enum DamageTypes {
	NORMAL,
	KARMA,
	FORCE,
	POISON,
	ROT,
	FATAL,
}
var normal_amount: int = 0
var karma_amount: int = 0
var karma_timer: float = 0
var poison_turns: int = 0
var poison_amount: int = 0 ## per turn / per 5 seconds
var poison_timer: float = 5
var force_amount: int = 0 # ignores armor

signal hp_updated
signal hp_hurtsound

func _process(delta: float) -> void:
	if normal_amount != 0:
		_handle_damage_normal()
	if karma_amount != 0:
		_handle_damage_karma(delta)
	if poison_amount != 0 and poison_turns != 0:
		_handle_damage_poison(delta)
	if force_amount != 0:
		pass


func heal_player(amount: int, override_effect = false) -> void:
	GlobalVars.player_hp = min(GlobalVars.player_hp + amount, GlobalVars.player_maxhp)
	if override_effect:
		normal_amount = 0
		karma_amount = 0
		karma_timer = 0
		force_amount = 0
		poison_turns = 0
		poison_amount = 0
		poison_timer = 0


func set_damage(amount: int, turns: int, damage_type: DamageTypes) -> void:
	hp_hurtsound.emit()
	match damage_type:
		DamageTypes.NORMAL:
			normal_amount += amount
		DamageTypes.KARMA:
			if GlobalVars.player_hp == 1: # if we get more karma at 1 hp then we die
				GlobalVars.player_hp = 0
			karma_amount += amount
		DamageTypes.POISON:
			poison_amount += amount
			poison_turns += turns
			poison_timer = 5

func _handle_damage_none() -> void:
	return

func _handle_damage_normal() -> void:
	var damage = max(1, normal_amount - GlobalVars.player_df)
	if normal_amount <= 0:
		damage = 0
	GlobalVars.player_hp = max(0, GlobalVars.player_hp - damage)
	GlobalVars.update_stats.emit()
	hp_updated.emit()
	normal_amount = 0

func _handle_damage_karma(delta: float) -> void:
	if karma_amount > 40: # any excess turns to damage, karma doesnt care about armor.
		GlobalVars.player_hp -= karma_amount - 40
		karma_amount = 40
	if karma_amount <= 0 or GlobalVars.player_hp <= 1:
		karma_amount = 0
		karma_timer = 0
		GlobalVars.update_stats.emit()
		hp_updated.emit()
	
	var frame_wait: int
	
	if karma_amount >= 40:
		frame_wait = 1
	elif karma_amount >= 30 and karma_amount <= 39:
		frame_wait = 2
	elif karma_amount >= 20 and karma_amount <= 29:
		frame_wait = 5
	elif karma_amount >= 10 and karma_amount <= 19:
		frame_wait = 15
	else:
		frame_wait = 30
	
	karma_timer += delta
	
	var time_to_wait = frame_wait * 0.033
	while karma_timer >= time_to_wait and karma_amount > 0:
		karma_timer -= time_to_wait
		karma_amount -= 1
		
		GlobalVars.player_hp = max(1, GlobalVars.player_hp - 1)
		GlobalVars.update_stats.emit()
		hp_updated.emit()

func _handle_damage_poison(delta: float) -> void:
	# add later a check for if we are in battle, and if we are then connect to a player_turn signal.
	# and then wait.
	if poison_amount >= GlobalVars.player_maxhp:
		poison_amount = GlobalVars.player_maxhp
	if poison_turns > 5: # 5 should be more than enough lmao
		poison_turns = 5
	if poison_turns <= 0:
		poison_amount = 0
		poison_turns = 0
		poison_timer = 0
		return
	
	poison_timer += delta
	
	if poison_timer >= 5:
		GlobalVars.player_hp = max(0, GlobalVars.player_hp - poison_amount)
		poison_timer = 0
		poison_turns -= 1
		GlobalVars.update_stats.emit()
		hp_updated.emit()
