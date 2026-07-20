extends PointLight2D
var orig_gradient: Gradient = self.texture.gradient
var current_offset: float = 0.2
var random_position: Vector2

func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(self, "current_offset", 0.4, 4.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "current_offset", 0.3, 4.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	#self.texture.gradient.set_offset(1, )

func _process(delta: float) -> void:
	texture.gradient.set_offset(1, current_offset)
	offset = offset.lerp(random_position, delta * 0.5)

func _on_position_timer_timeout() -> void:
	random_position = Vector2(randf_range(-10.0, 10.0), randf_range(-10.0, 10.0))
