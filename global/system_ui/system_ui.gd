extends CanvasLayer

@onready var text_label = $MarginContainer/RichTextLabel
var lock: bool = false
var timer: float = 0

signal text_end

enum states {
	IDLE,
	EXIT,
	TEXT,
	SPECIAL,
}
var state: states = states.IDLE

var custom_msg: String
var custom_timer: int
var custom_fadein: bool
var custom_fadeout: bool


func _ready() -> void:
	text_label.modulate = Color(1.0, 0.0, 0.0, 0.0)


func set_text(msg: String, timer: int = 3, fadein: bool = true, fadeout: bool = false) -> void:
	custom_msg = msg
	custom_timer = timer
	custom_fadein = fadein
	custom_fadeout = fadeout
	_set_state(states.TEXT)


func _process(delta: float) -> void:
	match state:
		states.IDLE:
			_handle_idle_state(delta)
		states.EXIT:
			_handle_exit_state(delta)
		states.TEXT:
			_handle_text_state(delta)
		states.SPECIAL:
			_handle_special_state(delta)


func _handle_idle_state(delta: float) -> void:
	if Input.is_action_just_pressed("exitting"):
		_set_state(states.EXIT)
		return


func _handle_exit_state(delta: float) -> void:
	if not Input.is_action_pressed("exitting"):
		_set_state(states.IDLE)
		return
	var dots_count = int(timer * 3)
	text_label.text = " Quitting" + ".".repeat(min(dots_count, 3))
	timer += delta
	if timer >= 1:
		get_tree().quit()


func _handle_text_state(delta: float) -> void:
	timer += delta
	if timer >= custom_timer:
		_set_state(states.IDLE)


func _handle_special_state(delta: float) -> void:
	pass


func _set_state(new_state: states) -> void:
	match state: # state leaving
		states.EXIT:
			timer = 0
			$Fader.play("RESET")
		states.TEXT:
			timer = 0
			if custom_fadeout:
				$Fader.play("fade")
			else:
				$Fader.play("RESET")

	match new_state: # state enter
		states.EXIT:
			$Fader.play_backwards("fade")
		states.TEXT:
			if custom_fadein:
				$Fader.play_backwards("fade")
			text_label.text = " " + custom_msg

	text_end.emit()
	state = new_state
