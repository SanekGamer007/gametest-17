@tool
extends Marker2D

@export var ID: String = "A":
	set(value):
		ID = value
		_update_label()
@export var facing: Chara.facings = Chara.facings.UP

func _ready() -> void:
	if not Engine.is_editor_hint():
		visible = false
	else:
		_update_label()


func _update_label() -> void:
	if has_node("Label"): 
		$Label.text = ID
		name = "SpawnPoint" + ID
