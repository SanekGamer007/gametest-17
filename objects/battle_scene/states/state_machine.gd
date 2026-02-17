extends Node
class_name BattleStateMachine

@onready var battle_scene: BattleScene = get_parent()

@export var starter_state: BattleState
var states: Dictionary[String, BattleState] = {}
var state: BattleState

func _ready() -> void:
	for child in get_children():
		if child is BattleState:
			states.set(child.name, child)
	
	if starter_state:
		_set_state(starter_state)

func _physics_process(delta: float) -> void:
	if state:
		state.update(delta)

func change_state(state_name: String) -> void:
	var new_state = states.get(state_name)
	if new_state:
		_set_state(new_state)
	else:
		push_error("FATAL: State not found.")

func _set_state(new_state: BattleState) -> void:
	if state:
		state.exit()
	state = new_state
	state.enter()
	print_debug("Transition to ", state, " state.")
