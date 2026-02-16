extends CanvasLayer

var showing: bool = false
var show_timer: float = 0.0
var lock: bool = false
var hp_hurt_tick: int = 0

func _ready() -> void:
	SceneManager.scene_changing.connect(_on_scene_change)
	HpManager.hp_updated.connect(show_hp)
	HpManager.hp_hurtsound.connect(_on_hpmanager_hp_hurtsound)
	$PanelContainer/HBoxContainer/VBoxContainer/HP.text = "%d / %d" % [GlobalVars.player_hp, GlobalVars.player_maxhp]
	$PanelContainer/HBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp)

func _process(delta: float) -> void:
	if showing:
		show_timer += delta
		if show_timer >= 2:
			$PopAnim.play("popout")
			show_timer = 0.0
			showing = false

func show_hp() -> void:
	if lock:
		return
	if not showing:
		$PopAnim.play("popin")
		showing = true
	show_timer = 0.0
	var real_poison_amount = HpManager.poison_amount * HpManager.poison_turns 
	if HpManager.karma_amount != 0:
		$PanelContainer/HBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp, HpManager.karma_amount, HpManager.DamageTypes.KARMA)
		$PanelContainer/HBoxContainer/VBoxContainer/HP.self_modulate = Color(1.0, 0.0, 1.0, 1.0) 
	elif real_poison_amount != 0:
		$PanelContainer/HBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp, real_poison_amount, HpManager.DamageTypes.POISON)
		$PanelContainer/HBoxContainer/VBoxContainer/HP.self_modulate = Color(0.0, 1.0, 0.0, 1.0)
	else:
		$PanelContainer/HBoxContainer/VBoxContainer/HP.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		$PanelContainer/HBoxContainer/HPProgressBar.update(GlobalVars.player_hp, GlobalVars.player_maxhp)
	$PanelContainer/HBoxContainer/VBoxContainer/HP.text = "%d / %d" % [GlobalVars.player_hp, GlobalVars.player_maxhp]

func _on_scene_change() -> void:
	if showing:
		$PopAnim.play("popout")
		show_timer = 0.0
		showing = false

func _on_hpmanager_hp_hurtsound() -> void:
	hp_hurt_tick += 1
	if hp_hurt_tick % 2 == 0:
		$AudioStreamPlayer.play()
