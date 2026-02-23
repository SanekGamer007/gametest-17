extends Node2D
const test = preload("res://levels/tests/fakeout_test/winow/window.tscn")
const uv_material: ShaderMaterial = preload("res://levels/tests/fakeout_test/uv.tres")
var min_value: float = 0.0
var max_value: float = 0.2
var enable_corruption: bool = false
@onready var tile_set = $Ruins.tile_set

var mult = 12
var all_valid_tiles = []
func _ready() -> void:
	get_viewport().set_embedding_subwindows(false)
	for i in tile_set.get_source_count():
		var source_id = tile_set.get_source_id(i)
		var source = tile_set.get_source(source_id)
		if source is TileSetAtlasSource:
			for tile_index in source.get_tiles_count():
				var atlas_coords = source.get_tile_id(tile_index)
				all_valid_tiles.append({"id": source_id, "atlas": atlas_coords})


func _physics_process(delta: float) -> void:
	if not enable_corruption:
		return
	var intensity = 0.00001
	var active_cells = $Ruins.get_used_cells()
	for cell in active_cells:
		if randf() < intensity * mult: # Вероятность порчи (0.5 = 50%)
			var random_data = all_valid_tiles.pick_random()
			$Ruins.set_cell(
				cell, 
				random_data["id"], 
				random_data["atlas"]
			)
	mult += 0.05

func corrupt_text() -> void:
	var box = get_tree().root.get_node_or_null("DialogueBox")
	if not box:
		print("oops")
		return
	var textwrite: TextWriter = box.get_node("TextWritter")
	textwrite.get_node("VBoxContainer/MarginContainer/RichTextLabel").material = uv_material
	var tween = create_tween().set_loops(-1)
	tween.tween_method(set_shader_value, min_value, max_value, 1.0).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(set_shader_value, max_value, min_value, 1.0).set_trans(Tween.TRANS_EXPO)

func grab_chara() -> void:
	var tween: Tween = create_tween()
	var fake_chara = $CharaAnimatedSprite2D
	fake_chara.visible = true
	$FloweyWines.material = uv_material
	tween.tween_property($FloweyWines, "position", fake_chara.position, 0.0)
	tween.parallel().tween_method(fake_chara.play, "up_idle", "down_idle", 0.0)
	tween.parallel().tween_property(fake_chara, "position", fake_chara.position + Vector2(0, -16), 0.0)
	tween.tween_method($FloweyWines.play, "default", "default", 0.0)
	tween.parallel().tween_property($FloweyWines, "position", $FloweyWines.position + Vector2(64,-64), 2)
	tween.parallel().tween_property($Camera2D, "offset", Vector2(64,-64), 2)
	tween.parallel().tween_property(fake_chara, "position", fake_chara.position + Vector2(64,-80), 2)
	get_tree().root.get_node("DialogueBox").offset = Tools.DIALOGUE_TOP_OFFSET

func increase_corruption() -> void:
	min_value += 0.2
	max_value += 0.4

func set_shader_value(value: float):
	uv_material.set_shader_parameter("corruption_level", value)

func _damage() -> void:
	var amount: int = ceil(GlobalVars.player_maxhp / 5.0)
	amount += GlobalVars.player_df
	if amount >= GlobalVars.player_hp + GlobalVars.player_df:
		amount = GlobalVars.player_hp + GlobalVars.player_df - 1
	HpManager.set_damage(amount, 0, HpManager.DamageTypes.NORMAL)

func crash() -> void:
	min_value = 0.5
	max_value = 1.0
	await get_tree().create_timer(15.0).timeout
	OS.delay_msec(10000)
	var a: Window = test.instantiate()
	get_tree().root.add_child(a)
	a.move_to_center()
	get_tree().paused = true
	await a.tree_exiting
	get_tree().quit()
