extends Area2D

# A good chunk of this code is shamelessly stolen from https://github.com/Stoxis/Godette-Tale/blob/master/Godette-Tale/Scripts/Player/InteractionComponent.gd.
@onready var parent: Chara = get_parent()
var interaction_targets: Array[Node]


func _physics_process(_delta: float) -> void:
	match parent.facing:
		parent.facings.UP:
			self.rotation_degrees = 180
			position.y = 10
		parent.facings.LEFT:
			self.rotation_degrees = 90
			position.y = 12
		parent.facings.DOWN:
			self.rotation_degrees = 0
			position.y = 5.5
		parent.facings.RIGHT:
			self.rotation_degrees = -90
			position.y = 12


func _input(event: InputEvent) -> void:
	if !interaction_targets.is_empty() and event.is_action_pressed("main_button") and parent.state != parent.states.BUSY:
		for target in interaction_targets:
			if target.has_method("interaction") and target.has_method("interaction_can_interact"):
				if target.interaction_can_interact():
					target.interaction(parent)
					break


func _on_area_entered(area: Area2D) -> void:
	_check_interact_entered(area)


func _on_area_exited(area: Area2D) -> void:
	_check_interact_exited(area)


func _check_interact_entered(area: CollisionObject2D):
	interaction_targets.append(area)


func _check_interact_exited(area: CollisionObject2D):
	if interaction_targets.has(area):
		var num = interaction_targets.find(area)
		interaction_targets.remove_at(num)
