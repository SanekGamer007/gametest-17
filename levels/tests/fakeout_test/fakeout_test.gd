extends Node2D
const test = preload("res://levels/tests/fakeout_test/winow/window.tscn")
const uv_material: ShaderMaterial = preload("res://levels/tests/fakeout_test/uv.tres")

func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)

func corrupt_text() -> void:
	var box = get_tree().root.get_node_or_null("DialogueBox")
	if not box:
		print("oops")
		return
	var textwrite: TextWriter = box.get_node("TextWritter")
	textwrite.get_node("VBoxContainer/MarginContainer/RichTextLabel").material = uv_material
	var tween = create_tween().set_loops(-1)
	tween.tween_method(set_shader_value, 0.0, 0.2, 1.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(set_shader_value, 0.2, 0.0, 1.0).set_trans(Tween.TRANS_EXPO)

func grab_chara() -> void:
	var tween: Tween = create_tween()
	var fake_chara = $CharaAnimatedSprite2D
	fake_chara.visible = true
	$FloweyWines.material = uv_material
	tween.parallel().tween_property($FloweyWines/ColorRect, "position", fake_chara.position + Vector2(6, 0), 0.5)
	tween.parallel().tween_property($FloweyWines/ColorRect2, "position", fake_chara.position - Vector2(6, 0) - Vector2($FloweyWines/ColorRect2.size.x, 0), 0.5)
	tween.tween_method(fake_chara.play, "up_idle", "down_idle", 0.0)
	
func set_shader_value(value: float):
	uv_material.set_shader_parameter("corruption_level", value)
