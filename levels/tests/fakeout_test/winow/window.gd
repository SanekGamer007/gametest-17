extends Window

func _ready() -> void:
	var username = GlobalVars.player_name
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"):
		username = OS.get_environment("USER")
	$TextEdit.text = $TextEdit.text.format({"username": username})
	close_requested.connect(queue_free)


func _on_clear_button_pressed() -> void:
	$TextEdit.text = ""


func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set($TextEdit.text)


func _on_abort_button_pressed() -> void:
	queue_free()
