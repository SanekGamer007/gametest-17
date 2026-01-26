extends Resource

class_name ItemResource

@export var item_name: String = ""
@export var description: Array[Dialogue]

@export var consume_on_use: bool = true


func on_use_overworld(serious: bool = false) -> Array[Dialogue]:
	var dialogue = DialogueText.new()
	dialogue.text = "If you are reading\nthis - i fucked up."
	return [dialogue]


func on_use_battle(serious: bool = false) -> Array[Dialogue]:
	var dialogue = DialogueText.new()
	dialogue.text = "If you are reading\nthis - i fucked up."
	return [dialogue]


func on_info() -> Array[Dialogue]:
	return description


func on_throw() -> Array[Dialogue]:
	var dialogue = DialogueText.new()
	var rng = randi_range(0, 25) # 20% chance to get unique dialogue.
	match rng:
		0:
			dialogue.text = "You bid a quiet farewell\n>to the %s." % item_name
		1:
			dialogue.text = "You put the %s\n>on the ground and gave it a\n>little pat." % item_name
		2:
			dialogue.text = "You threw the %s\n>on the ground like the piece\n>of trash it is." % item_name
		3:
			dialogue.text = "You abandoned the\n>%s." % item_name
		4:
			dialogue.text = "Nothing but somber goodbyes\n>for the %s" % item_name
		_:
			dialogue.text = "The %s was\n>thrown away." % item_name
	return [dialogue]
