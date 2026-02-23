extends TextureButton
var was_pressed: bool = false

var chara_soul
@export var normal: Texture2D
@export var focus: Texture2D
@export var offset: int = 8

func _ready() -> void:
	owner.init_complete.connect(_on_battle_scene_init_complete)

func _on_battle_scene_init_complete() -> void:
	chara_soul = owner.chara_soul

func _on_focus_entered() -> void:
	was_pressed = false
	texture_normal = focus
	chara_soul.global_position.x = global_position.x + offset


func _on_focus_exited() -> void: # godot overlays the default focus texture, but we need to replace it
	texture_normal = normal


func _on_pressed() -> void:
	was_pressed = true
