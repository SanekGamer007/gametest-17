extends Area2D

@onready var CollisionON: TileMapLayer = get_parent().get_node("CollisionON")
@onready var CollisionOFF: TileMapLayer = get_parent().get_node("CollisionOFF")
@onready var StairsTile: TileMapLayer = owner.get_node("StairsLayer2")
@onready var UniversalTile: TileMapLayer = owner.get_node("Universal")


func _on_body_entered(body: Node2D) -> void:
	if body is Chara:
		$CollisionShape2D2.shape.size = Vector2(20, 160)
		$CollisionShape2D2.position = Vector2(218, 170)
		CollisionON.enabled = true
		CollisionOFF.enabled = false
		StairsTile.z_index = 2
		UniversalTile.z_index = 2


func _on_body_exited(body: Node2D) -> void:
	if body is Chara:
		$CollisionShape2D2.shape.size = Vector2(20, 20)
		$CollisionShape2D2.position = Vector2(290, 170)
		CollisionON.enabled = false
		CollisionOFF.enabled = true
		StairsTile.z_index = -5
		UniversalTile.z_index = -5
