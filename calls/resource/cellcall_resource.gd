extends Resource

class_name CellCallResource

@export var cell_name: String = ""


func on_use() -> Array[Dialogue]:
	var dialogue = DialogueText.new()
	dialogue.text = "If you are reading\nthis - i fucked up."
	return [dialogue]
