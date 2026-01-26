extends Button

const HEART_TEXTURE: Texture2D = preload("res://objects/player_menu/sprites/heart1.png")
const NULL_TEXTURE: Texture2D = preload("res://objects/player_menu/sprites/heart3.png")
@onready var sound: AudioStreamPlayer = get_parent().get_node("AudioStreamPlayer")


func _on_focus_entered() -> void:
	icon = HEART_TEXTURE
	sound.play()


func _on_focus_exited() -> void:
	icon = NULL_TEXTURE


func _on_pressed() -> void:
	release_focus()


func _ready() -> void:
	owner.update_text.connect(_on_update_text)


func _on_update_text(_lvl_data: LevelData) -> void:
	if GlobalVars.player_contacts.size() == 0:
		visible = false
