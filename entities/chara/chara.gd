extends CharacterBody2D
class_name Chara
@onready var AnimSprite: AnimatedSprite2D = $AnimatedSprite2D

enum states {
	IDLE,
	WALK,
	RUN,
	BUSY, # to be used in cutscenes, menus, etc...
}

enum facings {
	DOWN,
	LEFT,
	RIGHT,
	UP,
}

var facing: facings = facings.DOWN
var state: states = states.IDLE
var direction: Vector2 = Vector2.ZERO
var can_open_menu: bool = true
@export var mv_speed: float = 100

func _ready() -> void:
	GlobalVars.disable_menu.connect(_disable_menu)
	GlobalVars.enable_menu.connect(_enable_menu)
	GlobalVars.player_start_busy.connect(_start_busy)
	GlobalVars.player_stop_busy.connect(_stop_busy)
	if SceneManager.new_target_spawn_id != "":
		_move_to_spawn_point()

func _physics_process(delta: float) -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")) # we are not using input.get_vector to avoid the circular deadzone.
	_manage_facings()
	match state:
		states.IDLE:
			_handle_idle_state(delta)
		states.WALK:
			_handle_walk_state(delta)
		states.RUN:
			_handle_run_state(delta)
		states.BUSY:
			_handle_busy_state()
	move_and_slide()

func set_state(new_state: states) -> void:
	if new_state == states.BUSY:
		match facing:
			facings.DOWN:
				_set_anim("down", false)
			facings.LEFT:
				_set_anim("left", false)
			facings.RIGHT:
				_set_anim("right", false)
			facings.UP:
				_set_anim("up", false)
		state = new_state
	else:
		state = new_state

func _handle_idle_state(_delta: float) -> void:
	velocity = Vector2.ZERO
	if direction:
		set_state(states.WALK)

func _handle_walk_state(_delta: float) -> void:
	if direction:
		velocity = direction * mv_speed
	else:
		set_state(states.IDLE)

func _handle_run_state(_delta: float) -> void:
	pass # TODO, maybe will remove.

func _handle_busy_state() -> void:
	velocity = Vector2.ZERO

func _manage_facings() -> void:
	if state == states.BUSY:
		return
	match direction: # if you switch directions to opposite ones in a single frame the facing will not update, TODO: maybe fix it.
		Vector2(0, 1):
			_set_facing(facings.DOWN)
		Vector2(-1, 0):
			_set_facing(facings.LEFT)
		Vector2(1, 0):
			_set_facing(facings.RIGHT)
		Vector2(0, -1):
			_set_facing(facings.UP)
	_manage_anims()

func set_facing_manual(new_facing: facings) -> void:
	_set_facing(new_facing)
	_manage_anims()

func _manage_anims() -> void:
	if state == states.BUSY:
		return
	if direction:
		match facing:
			facings.DOWN:
				_set_anim("down", true)
			facings.LEFT:
				_set_anim("left", true)
			facings.RIGHT:
				_set_anim("right", true)
			facings.UP:
				_set_anim("up", true)
	else:
		match facing:
			facings.DOWN:
				_set_anim("down", false)
			facings.LEFT:
				_set_anim("left", false)
			facings.RIGHT:
				_set_anim("right", false)
			facings.UP:
				_set_anim("up", false)

func _set_anim(new_anim: String, walk: bool) -> void:
	match new_anim:
		"down":
			if walk:
				$AnimatedSprite2D.play("down_walk")
			else:
				$AnimatedSprite2D.play("down_idle")
		"left":
			if walk:
				$AnimatedSprite2D.play("left_walk")
			else:
				$AnimatedSprite2D.play("left_idle")
		"right":
			if walk:
				$AnimatedSprite2D.play("right_walk")
			else:
				$AnimatedSprite2D.play("right_idle")
		"up":
			if walk:
				$AnimatedSprite2D.play("up_walk")
			else:
				$AnimatedSprite2D.play("up_idle")

func _set_facing(new_facing: facings) -> void:
	facing = new_facing

func _move_to_spawn_point() -> void:
	var spawn_points = get_tree().get_nodes_in_group("spawnpoint")
	for point: Marker2D in spawn_points:
		if point.ID == SceneManager.new_target_spawn_id:
			global_position = point.global_position
			set_facing_manual(point.facing)

func _disable_menu() -> void:
	can_open_menu = false

func _enable_menu() -> void:
	can_open_menu = true

func _start_busy() -> void:
	GlobalVars.emit_signal("disable_menu")
	set_state(states.BUSY)

func _stop_busy() -> void:
	GlobalVars.emit_signal("enable_menu")
	set_state(states.IDLE)
