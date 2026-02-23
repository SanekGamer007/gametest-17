extends Area2D
class_name Trigger

@export var only_activate_once: bool = false ## Resets when re-entering the room.
@export var start_busy: bool = false

var activated: bool = false
var chara: Chara

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	on_trigger_process(delta)

func _on_body_entered(body: Node2D) -> void:
	if body is Chara:
		chara = body
		if not only_activate_once or (only_activate_once and not activated):
			if trigger_start_condition():
				activated = true
				set_process(true)
				on_trigger_start()
				if start_busy:
					GlobalVars.player_start_busy.emit()

func _on_body_exited(body: Node2D) -> void:
	if body is Chara:
		chara = null
		if is_processing():
			set_process(false)
			on_trigger_end()

func trigger_start_condition() -> bool:
	return true

func on_trigger_start() -> void:
	pass

func on_trigger_process(delta: float) -> void:
	pass

func on_trigger_end() -> void:
	pass
