extends CharaSoulState

enum states {
	IDLE,
	MOVING,
	JUMPING,
	FALLING,
}

var state: states = states.IDLE
var direction: float
var newvelocity: Vector2
@export_group("Movement", "m_")
@export var m_max_fall_speed: float = 540.0
@export var m_fall_gravity: float = 320
@export var m_jump_gravity: float = 420.0
@export var m_jump_force: float = 240.0


func enter() -> void:
	chara_soul.motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	GlobalVars.update_vars() # temporary
	chara_soul.soul_sprite.modulate = Color(0.0, 0.0, 1.0, 1.0)

func update(delta: float) -> void:
	direction = Input.get_axis("left", "right") # we are not using input.get_vector to avoid the circular deadzone.
	match state:
		states.IDLE:
			_handle_idle_state()
		states.MOVING:
			_handle_moving_state()
		states.JUMPING:
			_handle_jumping_state(delta)
		states.FALLING:
			_handle_falling_state(delta)
	chara_soul.velocity.x = newvelocity.x
	chara_soul.velocity.y = clamp(newvelocity.y, -9999, m_max_fall_speed)

func exit() -> void:
	pass

func _handle_idle_state() -> void:
	newvelocity = Vector2.ZERO
	if not chara_soul.is_on_floor():
		set_state(states.FALLING)
	elif Input.is_action_pressed("up"):
		set_state(states.JUMPING)
	elif direction:
		set_state(states.MOVING)

func _handle_moving_state() -> void:
	if not chara_soul.is_on_floor():
		set_state(states.FALLING)
		return
	elif Input.is_action_pressed("up"):
		set_state(states.JUMPING)
	elif not direction:
		set_state(states.IDLE)
		return
	var speed = m_maxspeed
	if Input.is_action_pressed("second_button"):
		speed /= 2
	newvelocity.x = speed * direction

func _handle_jumping_state(delta: float) -> void:
	if newvelocity.y >= 0:
		set_state(states.FALLING)
		return
	if not Input.is_action_pressed("up"):
		if newvelocity.y < 0:
			newvelocity.y = 0
		set_state(states.FALLING)
		return
	var speed = m_maxspeed
	if Input.is_action_pressed("second_button"):
		speed /= 2
	newvelocity.x = speed * direction
	newvelocity.y += m_jump_gravity * delta
	
func _handle_falling_state(delta) -> void:
	if chara_soul.is_on_floor():
		if direction:
			set_state(states.MOVING)
		else:
			set_state(states.IDLE)
		return
	var speed = m_maxspeed
	if Input.is_action_pressed("second_button"):
		speed /= 2
	newvelocity.x = speed * direction
	newvelocity.y += m_fall_gravity * delta

func set_state(new_state: states) -> void:
	if new_state == states.JUMPING:
		newvelocity.y = -m_jump_force
	state = new_state
