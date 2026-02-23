extends Node2D
class_name Monster

@export var monster_name: String = ""
@export_category("Stats")
@export var hp: int = 0
@export var atk: int = 0
@export var def: int = 0
@export var experience: int = 0
@export var gold: int = 0
@export var item_drop: Array[ItemResource] # unused broken function restored from original.

@export_category("Behaviour")
@export var acts: Array[Resource] # TODO: Change to actresource when its done.
@export var attacks: Array[PackedScene] # TODO: Change to atk helper when thats done.

@export_category("Dialogue")
@export var description: Array[DialogueSeriesResource] # We are using DSR for an equilavent of Array[Array[Dialogue]]
@export var passive_dialogue: Array[DialogueSeriesResource]
@export var encounter_dialogue: Array[DialogueSeriesResource]

@export_category("Misc")
@export var position_offset: Vector2 = Vector2.ZERO ## This is an offset from the center. Leave at zero to not override.

var battle_scene: BattleScene
var battle_box: BattleBox
var chara_soul: CharaSoul

# TODO: Add needed returns to all funcs.

#region Behaviour hooks.

# NOTE: Change only when needed, for example in bosses.
# In regular monsters its not recommended.

func on_start() -> void:
	pass

func allow_player_turn() -> bool:
	return true
func pre_player_turn() -> void:
	pass
func post_player_turn(action: BattleManager.BattleAction) -> void:
	pass


func pre_self_turn() -> void:
	pass
func on_self_turn() -> void:
	pass
func post_self_turn() -> void:
	pass



func on_damage() -> void:
	pass
func on_death() -> void: # TODO: Expand.
	$GPUParticles2D.visible = true
	$Sprite2D.visible = false
	$GPUParticles2D.emitting = true

#endregion

#region Smart getters.

func get_description() -> Array[Dialogue]:
	return description[0].dialogue

func get_damage(amount: int) -> int:
	return amount

func get_attack() -> PackedScene:
	return attacks[0]

func get_death_item() -> Array[ItemResource]:
	return item_drop

func can_spare() -> bool:
	return true

func can_attack() -> BattleManager.BattleAttackTypes: # TODO: Make this smarter.
	return BattleManager.BattleAttackTypes.NORMAL

func can_run() -> bool:
	return true

#endregion

#region Dialogue getters.

func get_passive_dialogue() -> Array[Dialogue]: ## Dialogue between attacks.
	return passive_dialogue[0].dialogue

func get_encounter_dialogue() -> Array[Dialogue]: # Potentially move somewhere else.
	return encounter_dialogue[0].dialogue

#endregion

#region Initters.

func _init_name() -> void:
	pass

func _init_hp() -> void: # The point of these is to change the hp depending on various stuff.
	pass

func _init_atk() -> void:
	pass

func _init_def() -> void:
	pass

func _init_experience() -> void:
	pass

func _init_gold() -> void:
	pass

func _init_item_drop() -> void:
	pass

#endregion

func _decide_atk() -> void:
	pass
