extends Control 
@export var BG_COLOR: Color
@export var HP_COLOR: Color
@export var KARMA_COLOR: Color
@export var POISON_COLOR: Color

func update(hp: int, maxhp: int, effecthp: int = 0, effect: HpManager.DamageTypes = HpManager.DamageTypes.NORMAL) -> void:
	var hpsize = floor(hp * 1.25)
	var maxhpsize = floor(maxhp * 1.25)
	var effecthpsize = floor(effecthp * 1.25)
	if hpsize > maxhpsize:
		maxhpsize = hpsize # in case we have hp overflow from sleeping or smth else idk
	if effecthpsize > hpsize:
		effecthpsize = hpsize # safeguards
	$Background.color = BG_COLOR
	$Background.size.x = maxhpsize
	$Hp.color = HP_COLOR
	$Hp.size.x = hpsize
	$Effect.size.x = effecthpsize
	custom_minimum_size.x = maxhpsize
	if effect == HpManager.DamageTypes.NORMAL:
		$Effect.visible = false
	else:
		$Effect.visible = true
		$Effect.position.x = $Hp.size.x - effecthpsize
		match effect:
			HpManager.DamageTypes.KARMA:
				$Effect.color = KARMA_COLOR
			HpManager.DamageTypes.POISON:
				$Effect.color = POISON_COLOR
