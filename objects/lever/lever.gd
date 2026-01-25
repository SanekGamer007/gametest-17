extends Area2D

signal activated(parent: Node, target: Node, state: bool)

@export var only_activate_once: bool

var state_activated: bool = false


func interaction(player: Chara) -> void:
	$AudioStreamPlayer.play()
	if !state_activated:
		$AnimatedSprite2D.play("pressed")
		activated.emit(self, player, true)
		state_activated = true
	else:
		$AnimatedSprite2D.play("default")
		activated.emit(self, player, false)
		state_activated = false


func interaction_can_interact() -> bool:
	if state_activated and only_activate_once:
		return false
	return true


func play(anim: String) -> void:
	$AnimatedSprite2D.play(anim)


func set_state(new_state: bool) -> void:
	if new_state:
		$AnimatedSprite2D.play("pressed")
		state_activated = true
	else:
		$AnimatedSprite2D.play("default")
		state_activated = false
