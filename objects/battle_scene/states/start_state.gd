extends BattleState
class_name BattleStartState
var monsters: Array[Monster]

## This script is really messy, sorry about that.

func enter() -> void:
	var markover: Marker2D = battle_scene.monster_spawn_location.get_node("Marker2DOverride")
	var spawn_node = battle_scene.monster_spawn_location
	
	if battle_resource:
		for i in battle_resource.monsters.size():
			var monster: Monster = battle_resource.monsters[i].instantiate()
			var mark: Marker2D = battle_scene.monster_spawn_location.get_node_or_null("Marker2D" + str(i))
			if monster.position_offset == Vector2.ZERO and mark:
				monster.position = mark.position
			else:
				monster.position = markover.position + monster.position_offset
			monster.battle_box = battle_scene.battle_box
			monster.battle_scene = battle_scene
			monster.chara_soul = battle_scene.chara_soul
			battle_scene.monster_spawn_location.add_child(monster, true)
			monsters.append(monster)
	
	for child in spawn_node.get_children():
		if child is Marker2D:
			child.queue_free()
	
	for monster in monsters:
		monster.on_start()
	
	for monster in monsters:
		if monster.allow_player_turn() == false:
			state_machine.change_state.call_deferred("EnemyTurnState")
			return
	battle_scene.monsters = monsters
	state_machine.change_state.call_deferred("PlayerTurnState")

func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
