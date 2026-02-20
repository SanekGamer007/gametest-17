extends CharaSoulState

enum states {
	IDLE,
	MOVING,
	JUMPING,
}

var state: states = states.IDLE
var direction: float
@export_group("Movement", "m_")

var m_maxspeed: float

func enter() -> void:
	GlobalVars.update_stats.connect(_on_update_stats)
	GlobalVars.update_vars() # temporary
	chara_soul.soul_sprite.modulate = Color(0.0, 0.0, 1.0, 1.0)

func _on_update_stats() -> void:
	m_maxspeed = GlobalVars.player_speed * 30

func update(_delta: float) -> void:
	direction = Input.get_axis("left", "right") # we are not using input.get_vector to avoid the circular deadzone.
	match state:
		states.IDLE:
			_handle_idle_state()
		states.MOVING:
			_handle_moving_state()

func exit() -> void:
	pass

func _handle_idle_state() -> void:
	chara_soul.velocity = Vector2.ZERO
	if direction:
		set_state(states.MOVING)

func _handle_moving_state() -> void:
	if not direction:
		set_state(states.IDLE)
	var speed = m_maxspeed
	if Input.is_action_pressed("second_button"):
		speed /= 2
	chara_soul.velocity.x = speed * direction

func set_state(new_state: states) -> void:
	state = new_state
