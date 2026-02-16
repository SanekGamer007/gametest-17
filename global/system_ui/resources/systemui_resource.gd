extends Resource
class_name SystemUIResource

@export_multiline var text: String = ""
@export var priority: int = 0
@export var duration: float = 3.0
@export var fade_in: bool = true
@export var fade_out: bool = false

signal end

func _sys_start(textlabel: RichTextLabel) -> void:
	textlabel.text = " " + text

func _sys_process(delta: float, textlabel: RichTextLabel) -> void:
	pass

func _sys_end(textlabel: RichTextLabel) -> void:
	end.emit()
