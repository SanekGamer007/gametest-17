extends Button

const HEART_TEXTURE: Texture2D = preload("res://objects/dialogue/dialogue_button/heart1.png")
const NULL_TEXTURE: Texture2D = preload("res://objects/dialogue/dialogue_button/heart3.png")


func _on_focus_entered() -> void:
	icon = HEART_TEXTURE


func _on_focus_exited() -> void:
	icon = NULL_TEXTURE
