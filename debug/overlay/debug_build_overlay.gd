extends CanvasLayer

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	if FileAccess.file_exists("res://commit.txt"):
		var file = FileAccess.open("res://commit.txt", FileAccess.READ)
		$Label.text = $Label.text % [GlobalVars.MAJOR_GAME_VERSION, GlobalVars.MINOR_GAME_VERSION, file.get_as_text()]
