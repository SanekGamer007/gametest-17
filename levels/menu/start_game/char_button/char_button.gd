extends Button

func _on_focus_entered() -> void:
	$RichTextLabel.modulate = Color("ffff00")


func _on_focus_exited() -> void:
	$RichTextLabel.modulate = Color("ffffff")
