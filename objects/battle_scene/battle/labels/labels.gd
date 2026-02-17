extends Control

@onready var battle_scene: BattleScene = get_parent()

func _ready() -> void:
	$HBoxContainer/PlayerName.text = GlobalVars.player_name
	$HBoxContainer/LV.text = "LV %d" % GlobalVars.player_love
	HpManager.hp_updated.connect(update_hp)
	update_hp()
	battle_scene.init_complete.connect(_on_init_complete)

func _on_init_complete() -> void:
	match battle_scene.battle_era:
		GlobalVars.Versions.GAMETEST:
			$HBoxContainer.anchor_left = 0.0275
		GlobalVars.Versions.DEMO:
			$HBoxContainer.anchor_left = 0.05

func update_hp() -> void:
	var real_poison_amount = HpManager.poison_amount * HpManager.poison_turns 
	if HpManager.karma_amount != 0:
		$HPHBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp, HpManager.karma_amount, HpManager.DamageTypes.KARMA)
		$HPHBoxContainer/HP.self_modulate = Color(1.0, 0.0, 1.0, 1.0) 
	elif real_poison_amount != 0:
		$HPHBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp, real_poison_amount, HpManager.DamageTypes.POISON)
		$HPHBoxContainer/HP.self_modulate = Color(0.0, 1.0, 0.0, 1.0)
	else:
		$HPHBoxContainer/HP.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		$HPHBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp)
	$HPHBoxContainer/HP.text = "%d / %d" % [GlobalVars.player_hp, GlobalVars.player_maxhp]
