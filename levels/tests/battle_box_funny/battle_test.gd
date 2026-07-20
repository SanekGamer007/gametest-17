extends Node2D
@export var test_dialogue: Array[Dialogue]
@export var test_dialogue2: Array[Dialogue]
@export var test_dialogue3: Array[Dialogue]
@export var test_dialogue4: Array[Dialogue]
@onready var box: BattleBox = $BattleBox

func _ready() -> void:
	$CharaSoul.state_machine.change_state("RedState")
	await get_tree().create_timer(1.5).timeout
	box.set_box_size(Vector2(240,160), 0.5, Tween.TRANS_QUAD)
	await box.finished_resizing
	box.set_box_position(Vector2(320, 240), 0.5, Tween.TRANS_QUAD)
	box.set_box_size(Vector2(568,240), 0.5, Tween.TRANS_QUAD)
	for i in range(0, 4):
		box.set_box_position(Vector2(320, 200), 1, Tween.TRANS_QUAD)
		await box.finished_moving
		box.set_box_position(Vector2(320, 320), 1, Tween.TRANS_QUAD)
		await box.finished_moving
	#return
	box.set_box_position(Vector2(320, 240), 0.5, Tween.TRANS_QUAD)
	$CharaSoul.state_machine.change_state("BlueState")
	await box.finished_moving
	box.set_box_size(Vector2(320,320), 0.5, Tween.TRANS_QUAD)
	box.set_box_position(Vector2(480, 320), 0.5, Tween.TRANS_QUAD)
	#box.set_dialogue(test_dialogue2)
	await get_tree().create_timer(6).timeout
	#box.set_dialogue(test_dialogue3)
	box.set_box_size(Vector2(360,200), 0.5, Tween.TRANS_QUAD)
	box.set_box_position(Vector2(240, 240), 0.5, Tween.TRANS_QUAD)
	await box.finished_moving
	box.set_box_rotation(360, 2, Tween.TRANS_SINE)
	await box.finished_rotating
	box.set_box_size(Vector2(340,160), 0.5, Tween.TRANS_QUAD)
	box.set_box_position(Vector2(320, 360), 0.5, Tween.TRANS_QUAD)
	await get_tree().create_timer(1.5).timeout
	#box.set_dialogue(test_dialogue4)
	box.set_box_size(Vector2(576,140), 0.5, Tween.TRANS_QUAD)
	await get_tree().create_timer(3).timeout
	$CharaSoul.state_machine.change_state("RedState")
	box.reset_dialogue()
	box.set_box_position(Vector2(320, 240), 1, Tween.TRANS_QUAD)
	box.set_box_size(Vector2(660,520), 1, Tween.TRANS_QUAD)
	#await box.finished_resizing
	#$AnimationPlayer.play("friend")
	
	
