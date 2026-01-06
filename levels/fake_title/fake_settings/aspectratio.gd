extends Button

var format_text = "ASPECT RATIO   %s"


func _ready() -> void:
	if GlobalVars.widescreenmode:
		text = format_text % "WIDESCREEN"
	else:
		text = format_text % "CLASSIC"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			GlobalVars.widescreenmode = !GlobalVars.widescreenmode
			_change_res()


func _change_res() -> void:
	if GlobalVars.widescreenmode:
		text = format_text % "WIDESCREEN"
		get_window().size = Vector2i(854, 480)
		get_window().content_scale_size = Vector2i(854, 480)
		get_window().move_to_center()
		#get_tree().root.size = Vector2i(854, 480)
	else:
		text = format_text % "CLASSIC"
		get_window().size = Vector2i(640, 480)
		get_window().content_scale_size = Vector2i(640, 480)
		get_window().move_to_center()
		#get_tree().root.size = Vector2i(640, 480)
