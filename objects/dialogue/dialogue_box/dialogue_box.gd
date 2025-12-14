extends CanvasLayer

const DialogueButtonPreload = preload("res://objects/dialogue/dialogue_button/dialogue_button.tscn")
@onready var DialogueRichText: RichTextLabel = $HBoxContainer/VBoxContainer/MarginContainer/RichTextLabel
@onready var SpeakerSprite: Sprite2D = $HBoxContainer/SpeakerParent/Sprite2D

var current_dialogue: Array[Dialogue]
var current_dialogue_item: int = 0
var next_item: bool = true

var player_node: Chara

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var callable = func(): queue_free()
	GlobalVars.connect("close_all_ui", callable)
	visible = false
	$HBoxContainer/VBoxContainer/button_container.visible = false
	player_node = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if current_dialogue_item >= current_dialogue.size():
		if !player_node:
			for i in get_tree().get_nodes_in_group("player"):
				player_node = i
			return
		GlobalVars.player_stop_busy.emit()
		queue_free()
		return

	if next_item == true:
		next_item = false
		var i = current_dialogue[current_dialogue_item]
		if i is DialogueText:
			visible = true
			_text_dialogue(i)
		elif i is DialogueFunction:
			visible = i.show_dialogue_box
			_function_resource(i)
		elif i is DialogueEnd:
			current_dialogue_item = current_dialogue.size()
		elif i is DialogueLabel:
			current_dialogue_item += 1
			next_item = true
		elif i is DialogueJump:
			_jump_resource(i)

func _text_dialogue(textresource: DialogueText) -> void:
	print(textresource.text)
	#var final_text = "* " + textresource.text.replace("\n", "\n* ")
	var final_text = _apply_custom_formatting(textresource.text)
	var text_without_square_brackets: String = _text_without_square_brackets(final_text)
	var DialogueLength = text_without_square_brackets.length()
	DialogueRichText.visible_characters = 0
	DialogueRichText.text = final_text
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and textresource.camera_position != Vector2(999.999, 999.999):
		var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		camera_tween.tween_property(camera, "global_position", textresource.camera_position, textresource.camera_transition_time)
	
	if !textresource.speaker_img:
		$HBoxContainer/SpeakerParent.visible = false
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 8)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 8)
	else:
		$HBoxContainer/SpeakerParent.visible = true
		SpeakerSprite.texture = textresource.speaker_img
		SpeakerSprite.hframes = textresource.speaker_img_Hframes
		SpeakerSprite.frame = 0
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 0)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 0)
	
	while DialogueRichText.visible_characters < DialogueLength:
		if Input.is_action_pressed("second_button") and textresource.can_be_skipped == true:
			DialogueRichText.visible_characters = DialogueLength - 1
		DialogueRichText.visible_characters += 1
		var character = text_without_square_brackets[DialogueRichText.visible_characters - 1]
		if character != " ":
			$AudioStreamPlayer.pitch_scale = randf_range(textresource.text_volume_pitch_min, textresource.text_volume_pitch_max)
			$AudioStreamPlayer.play()
			if textresource.speaker_img_Hframes != 1:
				if SpeakerSprite.frame < textresource.speaker_img_Hframes - 1:
					SpeakerSprite.frame += 1
				else:
					SpeakerSprite.frame = 0
		await get_tree().create_timer(1 / textresource.text_speed).timeout
	
	SpeakerSprite.frame = min(textresource.speaker_img_rest_frame, textresource.speaker_img_Hframes - 1)
	
	while true:
		await get_tree().process_frame
		if DialogueRichText.visible_characters == DialogueLength:
			if Input.is_action_pressed("main_button"):
				current_dialogue_item += 1
				next_item = true
				break

func _function_resource(functionresource: DialogueFunction) -> void:
	var target_node = get_node(functionresource.target_path)
	if target_node.has_method(functionresource.function_name):
		if functionresource.function_arguments.size() == 0:
			target_node.call(functionresource.function_name)
		else:
			target_node.callv(functionresource.function_name, functionresource.function_arguments)
			
	if functionresource.wait_for_signal_to_continue:
		var signal_name = functionresource.wait_for_signal_to_continue
		if target_node.has_signal(signal_name):
			var signal_state = { "done": false }
			var callable = func(_args): signal_state.done = true
			target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame

	if functionresource.wait_time != 0.0:
		await get_tree().create_timer(functionresource.wait_time).timeout
	
	current_dialogue_item += 1
	next_item = true

func _jump_resource(jumpresource: DialogueJump) -> void:
	var jump_label = jumpresource.jump_label
	for i in current_dialogue.size():
		if current_dialogue[i] is DialogueLabel and current_dialogue[i].label_id == jump_label:
			current_dialogue_item = i
			next_item = true
			print("sds")
			break

func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false
	
	for i in text:
		if i == "[":
			inside_bracket = true
			continue
		
		if i == "]":
			inside_bracket = false
			continue
		
		if !inside_bracket:
			result += i

	return result

func _apply_custom_formatting(raw_text: String) -> String:
	var lines = raw_text.split("\n")
	var new_lines: Array[String] = []
	
	for line in lines:
		if line.begins_with(">"):
			new_lines.append(line.replace(">", "  ")) 
		else:
			new_lines.append("* " + line)
	return "\n".join(new_lines)
