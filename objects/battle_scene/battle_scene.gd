extends CanvasLayer
class_name BattleScene

signal init_complete

@onready var battlestatemachine: BattleStateMachine = $StateMachine
@onready var battle_box: BattleBox = $Control/BattleBox
@onready var chara_soul: CharaSoul = $CharaSoul

@onready var monster_spawn_location = $Monsters

var battle_resource: BattleResource
var battle_era: GlobalVars.Versions = GlobalVars.Versions.ANY
var monsters: Array[Monster]

func _ready() -> void:
	if battle_era == GlobalVars.Versions.ANY:
		if get_tree().current_scene.get_node_or_null("LevelData"):
			battle_era = get_tree().current_scene.get_node("LevelData").room_version
	init_complete.emit()

func _physics_process(delta: float) -> void:
	if GlobalVars.player_hp <= 0:
		SceneManager.change_scene("res://levels/misc/game_over/game_over.tscn", "A", "none", ".", "set_soul_pos", [$CharaSoul.global_position])
