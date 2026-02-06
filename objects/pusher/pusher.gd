@tool
extends Area2D

@export var direction: Vector2

var chara
var text_already: bool = false

@export_multiline var rare_text: Array[String] ## 5% chance to trigger.
@export_multiline var common_text: Array[String] ## 95% chance to trigger.


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	$Sprite2D.visible = false
	SystemUI.text_end.connect(_on_systemui_text_end)
	if GlobalVars.has_beaten_demo:
		pass
		#queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Chara:
		chara = body


func _on_body_exited(body: Node2D) -> void:
	if body is Chara:
		chara = null


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if get_node_or_null("CollisionShape2D"):
			$Sprite2D.position = $CollisionShape2D.position
		$Sprite2D.rotation = direction.angle()
	if chara:
		chara.position += direction * 240 * delta
		var text: String
		if not text_already:
			var rand = randi_range(1, 20)
			if rand == 10:
				if GlobalVars.player_fun == 66 and not GlobalVars.get_flag("pusher_secret_prereveal1", false):
					var rand2 = randi_range(1, 5)
					if rand2 == 5:
						text = "Something gazed at you.\n You feel fear crawling up your spine."
						GlobalVars.set_flag("pusher_secret_prereveal1", true)
					else:
						text = rare_text.pick_random()
				else:
					text = rare_text.pick_random()
			else:
				text = common_text.pick_random()
			SystemUI.set_text(text, 3, true, true)
			text_already = true


func _on_systemui_text_end() -> void:
	text_already = false
