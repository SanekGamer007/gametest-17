extends Node2D
var test_material: ShaderMaterial = preload("res://levels/tests/corruption/test.tres")
@onready var tile_set = $Ruins.tile_set
var all_valid_tiles = []
var mult = 1

func _ready() -> void:
	for i in tile_set.get_source_count():
		var source_id = tile_set.get_source_id(i)
		var source = tile_set.get_source(source_id)
		if source is TileSetAtlasSource:
			for tile_index in source.get_tiles_count():
				var atlas_coords = source.get_tile_id(tile_index)
				all_valid_tiles.append({"id": source_id, "atlas": atlas_coords})

func _physics_process(delta: float) -> void:
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
	if get_tree().get_first_node_in_group("player"):
		get_tree().get_first_node_in_group("player").get_node("AnimatedSprite2D").material = test_material
		test_material.set_shader_parameter("corruption_level", (intensity * mult) * 1000)
	mult += 0.05
	print(intensity * mult)
