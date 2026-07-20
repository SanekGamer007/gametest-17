extends Sprite2D
var player: Chara

@export var speed: float = 48

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	$PointLight2D.texture.gradient.set_color(0, Color.from_hsv(randf_range(0.0, 1.0), randf_range(0.7, 1.0), 1.0))
	if player:
		var direction: Vector2 = position.direction_to(player.position)
		position += (speed * direction) * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Chara:
		HpManager.set_damage(GlobalVars.player_maxhp / 4, 1, HpManager.DamageTypes.FATAL)
		var direction: Vector2 = position.direction_to(player.position)
		position += -direction * speed * 2
