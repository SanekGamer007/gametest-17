extends CharaSoulState

enum states {
	IDLE,
	MOVING,
}

var state: states = states.IDLE
var direction: Vector2
var newvelocity: Vector2

func enter() -> void:
	chara_soul.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	GlobalVars.update_vars() # temporary
	chara_soul.soul_sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)

func update(_delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")) # we are not using input.get_vector to avoid the circular deadzone.
	if chara_soul.is_on_wall() and direction.length() >= 1:
		direction = direction.normalized()
	match state:
		states.IDLE:
			_handle_idle_state()
		states.MOVING:
			_handle_moving_state()
	chara_soul.velocity = newvelocity

func exit() -> void:
	pass

func _handle_idle_state() -> void:
	chara_soul.velocity = Vector2.ZERO
	if direction:
		set_state(states.MOVING)

func _handle_moving_state() -> void:
	if not direction:
		set_state(states.IDLE)
	var speed: int = GlobalVars.player_speed * 30 # the original speed is in px/frame but we need in px/second
	if Input.is_action_pressed("second_button"):
		speed /= 2
	newvelocity = speed * direction

func set_state(new_state: states) -> void:
	state = new_state
