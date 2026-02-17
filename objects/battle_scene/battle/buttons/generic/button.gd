extends TextureButton
var was_pressed: bool = false

@onready var heart_button: TextureRect = $"../../TextureRect"
@export var normal: Texture2D
@export var focus: Texture2D
@export var offset: int = 8

func _on_focus_entered() -> void:
	texture_normal = focus
	heart_button.global_position.x = global_position.x + offset


func _on_focus_exited() -> void: # godot overlays the default focus texture, but we need to replace it
	texture_normal = normal


func _on_pressed() -> void:
	was_pressed = true
