extends Area2D
# A good chunk of this code is shamelessly stolen from https://github.com/Stoxis/Godette-Tale/blob/master/Godette-Tale/Scripts/Player/InteractionComponent.gd.
@onready var parent: Chara = get_parent()
var interaction_target : Node

func _physics_process(_delta: float) -> void:
	match parent.facing:
		parent.facings.UP:
			self.rotation_degrees = 180
			position.y = 10
		parent.facings.LEFT:
			self.rotation_degrees = 90
			position.y = 8
		parent.facings.DOWN:
			self.rotation_degrees = 0
			position.y = 5.5
		parent.facings.RIGHT:
			self.rotation_degrees = -90
			position.y = 8
	if (interaction_target != null and Input.is_action_just_pressed("main_button") and parent.state != parent.states.BUSY):
		if (interaction_target.has_method("interaction")):
				interaction_target.interaction(parent)

func _on_body_entered(body: Node2D) -> void:
	_check_interact_entered(body)

func _on_body_exited(body: Node2D) -> void:
	_check_interact_exited(body)

func _on_area_entered(area: Area2D) -> void:
	_check_interact_entered(area)

func _on_area_exited(area: Area2D) -> void:
	_check_interact_exited(area)

func _check_interact_entered(area: CollisionObject2D):
	var canInteract: bool = false
	print(area)
	if (area.has_method("interaction_can_interact")):
		canInteract = area.interaction_can_interact()
		print(canInteract)
	if not canInteract:
		return
	interaction_target = area
	
func _check_interact_exited(area: CollisionObject2D):
	if (area == interaction_target):
		interaction_target = null
