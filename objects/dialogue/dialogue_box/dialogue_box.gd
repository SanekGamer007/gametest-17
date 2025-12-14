@icon("res://objects/dialogue/resources/icons/dialogue.svg")
extends CanvasLayer

const DialogueButtonPreload: PackedScene = preload("res://objects/dialogue/dialogue_button/dialogue_button.tscn")
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
		match i.get_script():
			DialogueText:
				visible = true
				_text_dialogue(i)
			DialogueChoice:
				_choice_resource(i)
			DialogueEnd:
				current_dialogue_item = current_dialogue.size()
			DialogueLabel:
				current_dialogue_item += 1
				next_item = true
			DialogueConditionalJump:
				_conditional_jump_resource(i)
			DialogueAction:
				_do_action(i.req_action)
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

func _choice_resource(choiceresource: DialogueChoice) -> void:
	$HBoxContainer/VBoxContainer/button_container.visible = true
	var final_text = _apply_custom_formatting(choiceresource.text)
	var text_without_square_brackets: String = _text_without_square_brackets(final_text)
	var DialogueLength = text_without_square_brackets.length()
	DialogueRichText.visible_characters = 0
	DialogueRichText.text = final_text
	if !choiceresource.speaker_img:
		$HBoxContainer/SpeakerParent.visible = false
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 8)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 8)
	else:
		$HBoxContainer/SpeakerParent.visible = true
		SpeakerSprite.texture = choiceresource.speaker_img
		SpeakerSprite.hframes = choiceresource.speaker_img_Hframes
		SpeakerSprite.frame = 0
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 0)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 0)
	
	while DialogueRichText.visible_characters < DialogueLength:
		if Input.is_action_pressed("second_button") and choiceresource.can_be_skipped == true:
			DialogueRichText.visible_characters = DialogueLength - 1
		DialogueRichText.visible_characters += 1
		var character = text_without_square_brackets[DialogueRichText.visible_characters - 1]
		if character != " ":
			$AudioStreamPlayer.pitch_scale = randf_range(choiceresource.text_volume_pitch_min, choiceresource.text_volume_pitch_max)
			$AudioStreamPlayer.play()
			if choiceresource.speaker_img_Hframes != 1:
				if SpeakerSprite.frame < choiceresource.speaker_img_Hframes - 1:
					SpeakerSprite.frame += 1
				else:
					SpeakerSprite.frame = 0
		await get_tree().create_timer(1 / choiceresource.text_speed).timeout
	
	SpeakerSprite.frame = min(choiceresource.speaker_img_rest_frame, choiceresource.speaker_img_Hframes - 1)
	
	var buttonarray: Array[Button]
	
	for i in choiceresource.choice_text.size(): #buttons dont have a visible_characts variable so we have to do whatever this is.
		var dialoguebutton: Button = DialogueButtonPreload.instantiate()
		dialoguebutton.text = ""
		$HBoxContainer/VBoxContainer/button_container/VFlowContainer.add_child(dialoguebutton)
		buttonarray.append(dialoguebutton)
		
	var buttonpressed = (func(btn_idx: int):
		for i in $HBoxContainer/VBoxContainer/button_container/VFlowContainer.get_children():
			i.queue_free()
		$HBoxContainer/VBoxContainer/button_container.visible = false
		if choiceresource.choice_action_id[btn_idx] is not ActionNull:
			_do_action(choiceresource.choice_action_id[btn_idx])
			return
		else:
			current_dialogue_item += 1
			next_item = true
			return
		)
		
	for i in buttonarray.size():
		for x in choiceresource.choice_text[i].length():
			if Input.is_action_pressed("second_button") and choiceresource.can_be_skipped == true:
				buttonarray[i].text = choiceresource.choice_text[i]
				break
			buttonarray[i].text = buttonarray[i].text + choiceresource.choice_text[i][x]
			await get_tree().create_timer(1 / choiceresource.text_speed).timeout
		buttonarray[i].pressed.connect(buttonpressed.bind(i))
	buttonarray[0].grab_focus()

func _conditional_jump_resource(condjumpresource: DialogueConditionalJump) -> void:
	var result: bool
	if condjumpresource.var_variable and !condjumpresource.flag_name:
		var second_option
		if condjumpresource.var_variant:
			second_option = condjumpresource.var_variant
		elif condjumpresource.var_variable_two:
			second_option = condjumpresource.var_variable_two
		else:
			printerr("Invalid ConditionalJump Variable Options, Ignoring...")
		result = condjumpresource.var_variable == second_option
	elif condjumpresource.flag_name and !condjumpresource.var_variable:
		var second_option
		if condjumpresource.flag_variant:
			second_option = condjumpresource.flag_variant
		elif condjumpresource.var_variable_two:
			second_option = get_node(condjumpresource.var_target_path).get(condjumpresource.var_variable_two)
		else:
			printerr("Invalid ConditionalJump Flag Options, Ignoring...")
		result = GlobalVars.get_flag(condjumpresource.flag_name) == second_option
	else:
		printerr("Invalid ConditionalJump Type, Ignoring...")
		return
	
	if result:
		_jump(condjumpresource.jump_label_true)
	else:
		_jump(condjumpresource.jump_label_false)

func _do_action(actionresource: Action) -> void:
	if actionresource is ActionJump:
		for i in current_dialogue.size():
			if current_dialogue[i] is DialogueLabel and current_dialogue[i].label_id == actionresource.jump_label:
				current_dialogue_item = i
				next_item = true
				break
	
	elif actionresource is ActionFunction:
		visible = actionresource.show_dialogue_box
		var target_node = get_node(actionresource.target_path)
		if target_node.has_method(actionresource.function_name):
			if actionresource.function_arguments.size() == 0:
				target_node.call(actionresource.function_name)
			else:
				target_node.callv(actionresource.function_name, actionresource.function_arguments)
		if actionresource.wait_for_signal_to_continue:
			var signal_name = actionresource.wait_for_signal_to_continue
			if target_node.has_signal(signal_name):
				var signal_state = { "done": false }
				var callable = func(_args): signal_state.done = true
				target_node.connect(signal_name, callable, CONNECT_ONE_SHOT)
				while not signal_state.done:
					await get_tree().process_frame
		if actionresource.wait_time != 0.0:
			await get_tree().create_timer(actionresource.wait_time).timeout
	
	elif actionresource is ActionSet:
		if actionresource.flag_name:
			GlobalVars.set_flag(actionresource.flag_name, actionresource.flag_value)
		elif actionresource.var_target_path:
			var node = actionresource.var_target_path
			var vartoset = actionresource.var_name
			var value = actionresource.var_value
			get_node(node).set(vartoset, value) #there's a probably a safer way to do this.
		else: 
			printerr("Invalid ActionSet Type, Ignoring...")
	
	elif actionresource is Action:
		printerr("you forgot to set action type.")
	
	else:
		printerr("Invalid Action type, skipping.")
	
	current_dialogue_item += 1
	next_item = true

func _jump(jump_id: String) -> void:
	for i in current_dialogue.size():
		if current_dialogue[i] is DialogueLabel and current_dialogue[i].label_id == jump_id:
			current_dialogue_item = i
			next_item = true
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
