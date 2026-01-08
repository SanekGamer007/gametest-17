extends Control

var anim_ended: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_button") or event.is_action_pressed("second_button"):
		$AnimationPlayer.speed_scale = 99
		if anim_ended:
			SceneManager.change_scene("res://levels/menu/real_title/real_title.tscn", "A", "none")


func _ready() -> void:
	$AnimationPlayer.play("intro")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		$AnimationPlayer.speed_scale = 1
		$AnimationPlayer.play("Logo")
		anim_ended = true
