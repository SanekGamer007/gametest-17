extends Node2D
class_name BattleBox
var current_dialogue: Array[Dialogue]
var context: Node = null
var tween_physics: Tween
var tween_visual: Tween
var tween_mover: Tween
var tween_rotation: Tween

signal finished_resizing
signal finished_moving
signal finished_rotating

signal battle_dialogue_end

@onready var leftcollision: CollisionShape2D = $LeftAnimatableBody2D/CollisionShape2D
@onready var rightcollision: CollisionShape2D = $RightAnimatableBody2D/CollisionShape2D
@onready var downcollision: CollisionShape2D = $BottomAnimatableBody2D/CollisionShape2D
@onready var upcollision: CollisionShape2D = $TopAnimatableBody2D/CollisionShape2D

func _ready() -> void:
	$Panel/TextWritter.current_dialogue = current_dialogue
	$Panel/TextWritter.context = context
	$Panel/TextWritter.request_visibility.connect(_set_visible)
	
func _set_visible(value: bool) -> void:
	$Panel/TextWritter.visible = value

func set_dialogue(dialogue: Array[Dialogue]) -> void:
	$Panel/TextWritter.set_dialogue(dialogue)

func reset_dialogue() -> void:
	var empty: Array[Dialogue] = [DialogueText.new()]
	$Panel/TextWritter.set_dialogue(empty)

func set_box_size(new_size: Vector2, duration: float = 0.5, trans: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT) -> void:
	var half_width: float = new_size.x / 2
	var half_height: float = new_size.y / 2
	if tween_physics or tween_visual:
		tween_physics.kill()
		tween_visual.kill()
		
	tween_physics = create_tween().set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween_visual = create_tween().set_parallel(true)
	tween_visual.tween_property($Panel, "size", new_size, duration).set_trans(trans).set_ease(easing)
	tween_visual.tween_property($Panel, "position", -new_size / 2, duration).set_trans(trans).set_ease(easing)
	
	tween_physics.tween_property($LeftAnimatableBody2D, "position", Vector2(-half_width, 0), duration).set_trans(trans).set_ease(easing)
	tween_physics.tween_property(leftcollision.shape, "normal", Vector2(new_size.normalized().x, 0), duration).set_trans(trans).set_ease(easing)
	
	tween_physics.tween_property($RightAnimatableBody2D, "position", Vector2(half_width, 0), duration).set_trans(trans).set_ease(easing)
	tween_physics.tween_property(rightcollision.shape, "normal", Vector2(-new_size.normalized().x, 0), duration).set_trans(trans).set_ease(easing)
	
	tween_physics.tween_property($BottomAnimatableBody2D, "position", Vector2(0, half_height), duration).set_trans(trans).set_ease(easing)
	tween_physics.tween_property(downcollision.shape, "normal", Vector2(0, -new_size.normalized().y), duration).set_trans(trans).set_ease(easing)
	
	tween_physics.tween_property($TopAnimatableBody2D, "position", Vector2(0, -half_height), duration).set_trans(trans).set_ease(easing)
	tween_physics.tween_property(upcollision.shape, "normal", Vector2(0, new_size.normalized().y), duration).set_trans(trans).set_ease(easing)
	
	tween_physics.set_parallel(false).tween_callback(finished_resizing.emit)

func set_box_position(new_position: Vector2, duration: float = 0.5, trans: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT) -> void:
	if tween_mover:
		tween_mover.kill()
	tween_mover = create_tween()
	tween_mover.tween_property(self, "position", new_position, duration).set_trans(trans).set_ease(easing)
	tween_mover.tween_callback(finished_moving.emit)

func set_box_rotation(new_degree: float, duration: float = 0.5, trans: Tween.TransitionType = Tween.TRANS_LINEAR, easing: Tween.EaseType = Tween.EASE_IN_OUT) -> void:
	if tween_rotation:
		tween_rotation.kill()
	tween_rotation = create_tween()
	tween_rotation.tween_property(self, "rotation_degrees", new_degree, duration).set_trans(trans).set_ease(easing)
	tween_rotation.tween_callback(finished_rotating.emit)
