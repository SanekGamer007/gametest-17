extends Trigger

@export var Dialogue_test: Array[Dialogue]

func on_trigger_start() -> void:
	Tools.start_dialogue(Dialogue_test, chara, self)
	var anim_name = chara.AnimSprite.animation
	anim_name.replace("walk", "idle")
	get_parent().get_node("CharaAnimatedSprite2D").visible = true
	chara.visible = false
	get_parent().get_node("CharaAnimatedSprite2D").play(anim_name)
	get_parent().get_node("CharaAnimatedSprite2D").global_position = chara.global_position
