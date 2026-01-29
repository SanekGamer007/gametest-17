extends Button

const HEART_TEXTURE: Texture2D = preload("res://objects/player_menu/sprites/heart1.png")
const NULL_TEXTURE: Texture2D = preload("res://objects/player_menu/sprites/heart3.png")
@onready var sound: AudioStreamPlayer = get_parent().get_node("AudioStreamPlayer")
var item_id: int

signal using(id: int, button: Button)


func _on_focus_entered() -> void:
	icon = HEART_TEXTURE
	sound.play()


func _on_focus_exited() -> void:
	icon = NULL_TEXTURE


func _on_pressed() -> void:
	using.emit(item_id, self)
