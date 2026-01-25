extends Area2D

signal activated(parent: Node, target: Node, state: bool)

@export var only_activate_once: bool

var state_activated: bool = false


func interaction_can_interact() -> bool:
	return false


func play(anim: String) -> void:
	$AnimatedSprite2D.play(anim)


func set_state(new_state: bool, silent: bool) -> void:
	if new_state:
		$AnimatedSprite2D.play("pressed")
		state_activated = true
	else:
		$AnimatedSprite2D.play("default")
		state_activated = false
	if not silent:
		$AudioStreamPlayer.play()


func _on_body_entered(body: Node2D) -> void:
	if body is Chara:
		if !state_activated:
			$AudioStreamPlayer.play()
			$AnimatedSprite2D.play("pressed")
			activated.emit(self, body, true)
			state_activated = true


func _on_body_exited(body: Node2D) -> void:
	if body is Chara:
		if state_activated and !only_activate_once:
			$AudioStreamPlayer.play()
			$AnimatedSprite2D.play("default")
			activated.emit(self, body, false)
			state_activated = false
