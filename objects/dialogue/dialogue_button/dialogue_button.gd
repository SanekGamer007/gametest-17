extends Button
const heartspr: Texture2D = preload("res://entities/chara/sprites/battle/heart.png")
const heartnullspr: Texture2D = preload("res://entities/chara/sprites/battle/heart_null.png")

func _process(_delta: float) -> void:
	if has_focus() and Input.is_action_just_pressed("main_button"):
		pressed.emit()


func _on_focus_entered() -> void:
	set_button_icon(heartspr)


func _on_focus_exited() -> void:
	set_button_icon(heartnullspr)
