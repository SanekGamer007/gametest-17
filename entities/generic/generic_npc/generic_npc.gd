extends CharacterBody2D
@export var able_to_interact: bool
signal animation_finished

func play(animname: String) -> void:
	$AnimatedSprite2D.play(animname)

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_finished.emit()
