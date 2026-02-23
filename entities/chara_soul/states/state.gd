extends Node
class_name CharaSoulState

@onready var state_machine: CharaSoulStateMachine = get_parent()
@onready var chara_soul: CharaSoul = get_parent().get_parent()

var m_maxspeed: float

func _ready() -> void:
	GlobalVars.update_stats.connect(_on_update_stats)

func _on_update_stats() -> void:
	m_maxspeed = GlobalVars.player_speed * 30

func enter() -> void:
	pass

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
