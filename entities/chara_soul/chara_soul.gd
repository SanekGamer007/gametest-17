extends CharacterBody2D
class_name CharaSoul

@onready var soul_sprite: Sprite2D = $Sprite2D
@onready var state_machine: CharaSoulStateMachine = $StateMachine
@export var starter_state: CharaSoulState
var tween_invin: Tween
var hp_hurt_tick: int = 0
signal init_complete

func _ready() -> void:
	init_complete.emit()
	HpManager.hp_invincibility.connect(_invicibility_anim)
	HpManager.hp_hurtsound.connect(_hp_hurtsound)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _invicibility_anim() -> void:
	var duration = GlobalVars.player_invincibility / 30.0
	if tween_invin:
		tween_invin.kill()
	var loops: int = floor(duration / 0.2)
	tween_invin = create_tween().set_loops(-1)
	tween_invin.tween_property($Sprite2D, "frame", 1, 0.1)
	tween_invin.tween_property($Sprite2D, "frame", 0, 0.1)
	while loops > 0:
		loops -= 1
		if loops < 1 and $HurtBox.has_overlapping_areas():
			loops += 1
		await tween_invin.loop_finished
	tween_invin.kill()

func _hp_hurtsound() -> void:
	if HpManager.karma_amount == 0:
		hp_hurt_tick = 0
		$AudioStreamPlayer.play()
		return
	hp_hurt_tick += 1
	if hp_hurt_tick % 2 == 0:
		$AudioStreamPlayer.play()
