extends Node2D
class_name BattleBox
var current_dialogue: Array[Dialogue]
var context: Node = null
var tween_physics: Tween = create_tween()
var tween_visual: Tween = create_tween()

@onready var leftcollision: CollisionShape2D = $AnimatableBody2D/LeftCollisionShape2D
@onready var rightcollision: CollisionShape2D = $AnimatableBody2D/RightCollisionShape2D
@onready var downcollision: CollisionShape2D = $AnimatableBody2D/DownCollisionShape2D
@onready var upcollision: CollisionShape2D = $AnimatableBody2D/UpCollisionShape2D

func _ready() -> void:
	$TextWritter.current_dialogue = current_dialogue
	$TextWritter.context = context
	$TextWritter.request_visibility.connect(_set_visible)
	
func _set_visible(value: bool) -> void:
	$TextWritter.visible = value

func set_dialogue(dialogue: Array[Dialogue]) -> void:
	$TextWritter.set_dialogue(dialogue)

func set_box_size(new_size: Vector2, duration: float = 0.5, origin: Vector2 = Vector2(0, 0)) -> void:
	var half_width: float = new_size.x / 2
	var half_height: float = new_size.y / 2
	if tween_physics or tween_visual:
		tween_physics.kill()
		tween_visual.kill()
		
	tween_physics = create_tween()
	tween_visual = create_tween()
	tween_physics.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween_visual.parallel().tween_property($Panel, "size", new_size, duration)
	tween_visual.parallel().tween_property($Panel, "position", origin - new_size / 2, duration)
	
	tween_physics.parallel().tween_property(leftcollision, "position", Vector2(-half_width, 0), duration)
	tween_physics.parallel().tween_property(leftcollision.shape, "a", Vector2(0, half_height), duration)
	tween_physics.parallel().tween_property(leftcollision.shape, "b", Vector2(0, -half_height), duration)
	
	tween_physics.parallel().tween_property(rightcollision, "position", Vector2(half_width, 0), duration)
	tween_physics.parallel().tween_property(rightcollision.shape, "a", Vector2(0, half_height), duration)
	tween_physics.parallel().tween_property(rightcollision.shape, "b", Vector2(0, -half_height), duration)
	
	tween_physics.parallel().tween_property(downcollision, "position", Vector2(0, half_height), duration)
	tween_physics.parallel().tween_property(downcollision.shape, "a", Vector2(half_width, 0), duration)
	tween_physics.parallel().tween_property(downcollision.shape, "b", Vector2(-half_width, 0), duration)
	
	tween_physics.parallel().tween_property(upcollision, "position", Vector2(0, -half_height), duration)
	tween_physics.parallel().tween_property(upcollision.shape, "a", Vector2(half_width, 0), duration)
	tween_physics.parallel().tween_property(upcollision.shape, "b", Vector2(-half_width, 0), duration)
