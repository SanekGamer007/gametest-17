extends CanvasLayer

@onready var text_label = $MarginContainer/RichTextLabel
var timer: float = 0

signal text_end

enum states {
	IDLE,
	EXIT,
	TEXT,
	SPECIAL,
}
var state: states = states.IDLE

var active_res: SystemUIResource = null
var queue: Array[SystemUIResource]

func _ready() -> void:
	text_label.modulate = Color(1.0, 1.0, 1.0, 0.0)


func add_text_helper(text: String, duration: int, priority: int) -> void:
	var res = SystemUIResource.new()
	for item in queue:
		if item.text == text and item.priority == priority:
			return
	res.text = text
	res.duration = duration
	res.priority = priority
	add_text(res)

func add_text(res: SystemUIResource) -> void:
	if queue.has(res): 
		return
	queue.append(res)
	queue.sort_custom(func(a, b): return a.priority > b.priority)
	if state == states.TEXT and queue[0] != active_res:
		_set_state(states.IDLE)

func remove_text_idx(idx: int) -> void:
	queue.pop_at(idx)

func remove_text_res(res: SystemUIResource) -> void:
	var idx = queue.find(res)
	remove_text_idx(idx)

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


func _handle_idle_state(_delta: float) -> void:
	if Input.is_action_just_pressed("exitting"):
		_set_state(states.EXIT)
		return
	elif not queue.is_empty():
		_set_state(states.TEXT)


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
	if not active_res:
		_set_state(states.IDLE)
		return
	timer += delta
	if timer >= active_res.duration:
		_set_state(states.IDLE)
	else:
		active_res._sys_process(delta, text_label)

func _handle_special_state(_delta: float) -> void:
	pass


func _set_state(new_state: states) -> void:
	match state: # state leaving
		states.EXIT:
			timer = 0
			$Fader.play("RESET")
		states.TEXT:
			timer = 0
			if active_res:
				if active_res.fade_out:
					$Fader.play("fade")
				else:
					$Fader.play("RESET")
				active_res._sys_end(text_label)

	match new_state: # state enter
		states.IDLE:
			if active_res:
				queue.erase(active_res)
				active_res = null
		states.EXIT:
			$Fader.play_backwards("fade")
		states.TEXT:
			if not queue.is_empty():
				active_res = queue[0]
				if active_res.fade_in:
					$Fader.play_backwards("fade")
				active_res._sys_start(text_label)

	text_end.emit()
	state = new_state
