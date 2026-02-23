extends Node
class_name CharaSoulStateMachine

@onready var chara_soul: CharaSoul = get_parent()

var states: Dictionary[String, CharaSoulState] = {}
var state: CharaSoulState

func _ready() -> void:
	for child in get_children():
		if child is CharaSoulState:
			states.set(child.name, child)
	
	chara_soul.init_complete.connect(_on_init_complete)
	
func _on_init_complete() -> void:
	if chara_soul.starter_state:
		_set_state(chara_soul.starter_state)

func _physics_process(delta: float) -> void:
	if state:
		state.update(delta)

func change_state(state_name: String) -> void:
	var new_state = states.get(state_name)
	if new_state:
		_set_state(new_state)
	else:
		push_error("Soul state not found.")

func _set_state(new_state: CharaSoulState) -> void:
	if state:
		state.exit()
	state = new_state
	state.enter()
	print_debug("Transition to ", state, " soul state.")
