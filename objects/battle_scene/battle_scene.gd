extends CanvasLayer
class_name BattleScene

signal init_complete

@onready var battlestatemachine: BattleStateMachine = $StateMachine
@onready var battle_box: BattleBox = $BattleBox
var battle_era: GlobalVars.Versions = GlobalVars.Versions.ANY

func _ready() -> void:
	if battle_era == GlobalVars.Versions.ANY:
		if get_tree().current_scene.get_node_or_null("LevelData"):
			battle_era = get_tree().current_scene.get_node("LevelData").room_version
	init_complete.emit()

func _physics_process(delta: float) -> void:
	pass
