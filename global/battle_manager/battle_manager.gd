extends Node
signal battle_start
signal battle_camera
signal battle_end

const BATTLE_TRANSITION = preload("res://objects/battle_transition/battle_transition.tscn")
const BATTLE_SCENE = preload("res://objects/battle_scene/battle_scene.tscn")

func start_battle(intro: bool = true, version: GlobalVars.Versions = GlobalVars.Versions.ANY) -> void:
	var battle_node: BattleScene = BATTLE_SCENE.instantiate()
	battle_node.battle_era = version
	GlobalVars.player_start_busy.emit()
	GlobalVars.close_all_ui.emit()
	BgmManager.stop_song(false)
	battle_start.emit()
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().current_scene.visible = false
	if intro:
		var transition_instance = BATTLE_TRANSITION.instantiate()
		get_tree().root.add_child(transition_instance)
		var transition_pos: Vector2
		if get_tree().current_scene.get_node_or_null("LevelData"):
			var era: GlobalVars.Versions = get_tree().current_scene.get_node("LevelData").room_version
			print(era)
			match era:
				GlobalVars.Versions.PROTO:
					transition_pos = Vector2(32, 454)
				GlobalVars.Versions.GAMETEST:
					transition_pos = Vector2(32, 454)
				_:
					transition_pos = Vector2(48, 454)
		transition_instance.start_transition(transition_pos)
		await transition_instance.finished
	get_tree().root.add_child(battle_node)
	battle_camera.emit()
