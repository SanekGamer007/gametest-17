extends Area2D

var chara
var text_already: bool = false


func _ready() -> void:
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


func _physics_process(_delta: float) -> void:
	if chara:
		chara.position.y += 4
		if not text_already:
			var rand = randi_range(0, 4)
			match rand:
				0:
					SystemUI.set_text("Not now.", 3, true, true)
				1:
					SystemUI.set_text("Maybe later.", 3, true, true)
				2:
					SystemUI.set_text("The time is not here just yet.\n But that might change very, very soon...", 3, true, true)
				3:
					SystemUI.set_text("Later.", 3, true, true)
				4:
					SystemUI.set_text("Be a [shake rate=15.0 level=2]little[/shake] more patient.", 3, true, true)
			text_already = true


func _on_systemui_text_end() -> void:
	text_already = false
