@icon("res://objects/dialogue/resources/icons/dialogue.svg")
class_name DialogueBox
extends CanvasLayer

const INVALID_TAGS: String = "\n,?! "
const DialogueButtonPreload: PackedScene = preload("res://objects/dialogue/dialogue_button/dialogue_button.tscn")

var context: Node = null
var current_dialogue: Array[Dialogue]
var current_dialogue_item: int = 0
var next_item: bool = true

@onready var DialogueRichText: RichTextLabel = $HBoxContainer/VBoxContainer/MarginContainer/RichTextLabel
@onready var SpeakerSprite: Sprite2D = $HBoxContainer/SpeakerParent/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var callable = func(): queue_free()
	GlobalVars.connect("close_all_ui", callable)
	visible = false
	$HBoxContainer/VBoxContainer/button_container.visible = false


func _process(_delta: float) -> void:
	if current_dialogue_item >= current_dialogue.size():
		GlobalVars.player_stop_busy.emit()
		queue_free()
		return
	if next_item == true:
		next_item = false
		var i = current_dialogue[current_dialogue_item]
		if i == null:
			var origin: String = str(context.name) if context else "null..."
			push_error("Dialogue ", current_dialogue_item, " in ", origin, " is null, you probably want to fix that, for now: ignoring...")
			GlobalVars.player_stop_busy.emit()
			queue_free()
			return
		match i.get_script():
			DialogueText:
				visible = true
				_text_resource(i)
			DialogueChoice:
				_choice_resource(i)
			DialogueEnd:
				current_dialogue_item = current_dialogue.size()
			DialogueLabel:
				current_dialogue_item += 1
				next_item = true
			DialogueConditionalAction:
				_conditional_action_resource(i)
			ActionJump:
				_do_action(i)
			ActionSet:
				_do_action(i)
			ActionFunction:
				_do_action(i)
			ActionNull:
				_do_action(i)
			DialogueMove:
				_do_tools(i)
			DialogueSound:
				_do_tools(i)
			DialogueWait:
				_do_tools(i)
			DialogueChangeAnim:
				_do_tools(i)
			_:
				push_error(i.get_script().get_global_name() + " is either not a valid dialogue type, or obsolete.")
				current_dialogue_item += 1
				next_item = true


func _text_resource(textresource: DialogueText) -> void:
	$AudioStreamPlayer.stream = textresource.text_sound
	$AudioStreamPlayer.volume_db = textresource.text_volume_db
	print(textresource.text) # i like it lol.
	var formatted_text: String = _apply_custom_formatting(textresource.text)
	#var text_no_square_brackets: String = _text_without_square_brackets(formatted_text)
	var final_text: String = _process_tags(formatted_text)
	DialogueRichText.text = final_text
	var DialogueLength = DialogueRichText.get_total_character_count()
	DialogueRichText.visible_characters = 0
	await _write_text(textresource, DialogueLength)
	while true:
		if Input.is_action_pressed("main_button") or textresource.auto_skip:
			current_dialogue_item += 1
			next_item = true
			break
		await get_tree().process_frame


func _choice_resource(choiceresource: DialogueChoice) -> void:
	$AudioStreamPlayer.stream = choiceresource.text_sound
	$AudioStreamPlayer.volume_db = choiceresource.text_volume_db
	$HBoxContainer/VBoxContainer/button_container.visible = true

	var formatted_text: String = _apply_custom_formatting(choiceresource.text)
	var text_no_square_brackets: String = _text_without_square_brackets(formatted_text)
	var final_text: String = _process_tags(text_no_square_brackets)
	var DialogueLength = final_text.length()
	var buttonarray: Array[Button] = []
	DialogueRichText.visible_characters = 0
	DialogueRichText.text = final_text

	await _write_text(choiceresource, DialogueLength)

	for i in range(choiceresource.choice_text.size()): #buttons dont have a visible_characts variable so we have to do whatever this is.
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
		var new_button_text: String = _process_tags(choiceresource.choice_text[i])
		buttonarray[i].text = _process_tags(buttonarray[i].text)
		for x in new_button_text.length():
			if Input.is_action_pressed("second_button") and choiceresource.can_be_skipped == true:
				buttonarray[i].text = new_button_text
				break
			buttonarray[i].text = buttonarray[i].text + new_button_text[x]
			$AudioStreamPlayer.pitch_scale = randf_range(choiceresource.text_volume_pitch_min, choiceresource.text_volume_pitch_max)
			$AudioStreamPlayer.play()
			await get_tree().create_timer(1 / choiceresource.text_speed).timeout
		buttonarray[i].pressed.connect(buttonpressed.bind(i))
	buttonarray[0].grab_focus()


func _conditional_action_resource(conditional_action: DialogueConditionalAction) -> void:
	var result_one: Variant
	var result_two: Variant
	var result: bool
	match conditional_action.value_one.get_script():
		ConditionalActionFlag:
			if !GlobalVars.has_flag(conditional_action.value_one.name):
				result_one = false
			result_one = GlobalVars.get_flag(conditional_action.value_one.name)
		ConditionalActionVar:
			result_one = Tools.get_target_node(conditional_action.value_one.target_path, context).get(conditional_action.value_one.name)
		ConditionalActionVariant:
			result_one = conditional_action.value_one.value
	match conditional_action.value_two.get_script():
		ConditionalActionFlag:
			if !GlobalVars.has_flag(conditional_action.value_two.name):
				result_two = false
			result_two = GlobalVars.get_flag(conditional_action.value_two.name)
		ConditionalActionVar:
			result_two = Tools.get_target_node(conditional_action.value_two.target_path, context).get(conditional_action.value_two.name)
		ConditionalActionVariant:
			result_two = conditional_action.value_two.value
	result = Tools.compare(result_one, result_two, conditional_action.operator)
	if result:
		_do_action(conditional_action.action_true)
	else:
		_do_action(conditional_action.action_false)


func _do_action(actionresource: Action) -> void:
	if actionresource is ActionJump:
		for i in current_dialogue.size():
			if current_dialogue[i] is DialogueLabel and current_dialogue[i].label_id == actionresource.jump_label:
				current_dialogue_item = i
				next_item = true
				break
	elif actionresource is ActionFunction:
		visible = actionresource.show_dialogue_box
		var target_node = Tools.get_target_node(actionresource.target_path, context)
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
			Tools.get_target_node(node, context).set(vartoset, value) #there's a probably a safer way to do this.
		else:
			push_error("Invalid ActionSet parameters, ignoring...")

	else:
		push_error("Invalid Action type, ignoring...")

	current_dialogue_item += 1
	next_item = true


func _do_tools(tool: Dialogue) -> void:
	visible = tool.show_dialogue_box
	match tool.get_script():
		DialogueMove:
			var tooltween: Tween = create_tween()
			if !tool.is_relative:
				tooltween.tween_property(
					Tools.get_target_node(tool.target_path, context),
					"position",
					tool.move_location,
					tool.move_duration,
				)
			else:
				tooltween.tween_property(
					Tools.get_target_node(tool.target_path, context),
					"position",
					Tools.get_target_node(tool.target_path, context).position + tool.move_location,
					tool.move_duration,
				)
			if tool.await_end:
				await tooltween.finished
		DialogueChangeAnim:
			var target = Tools.get_target_node(tool.target_path, context)
			target.play(tool.anim_name)
		DialogueWait:
			if !tool.wait_for_signal:
				await get_tree().create_timer(tool.wait_time).timeout
			else:
				var target = Tools.get_target_node(tool.target_path, context)
				if target and target.has_signal(tool.signal_name):
					await Signal(target, tool.signal_name)
				else:
					push_error('DialogueToolWait: Signal \"', tool.signal_name, '\" not found in \"', tool.target_path, '\".')
		DialogueSound:
			var sound = AudioStreamPlayer.new()
			sound.stream = tool.Sound
			sound.bus = "Sounds"
			get_tree().root.add_child(sound)
			sound.play()
			sound.finished.connect(sound.queue_free)
	current_dialogue_item += 1
	next_item = true


func _write_text(resource: Dialogue, DialogueLength: int) -> bool:
	if !resource.speaker_img:
		$HBoxContainer/SpeakerParent.visible = false
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 8)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 8)
	else:
		$HBoxContainer/SpeakerParent.visible = true
		SpeakerSprite.texture = resource.speaker_img
		SpeakerSprite.hframes = resource.speaker_img_hframes
		SpeakerSprite.frame = 0
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_left", 0)
		$HBoxContainer/VBoxContainer/MarginContainer.add_theme_constant_override("margin_right", 0)

	var clean_text_for_audio = DialogueRichText.get_parsed_text()
	var visible_chars_float: float = 0.0

	while DialogueRichText.visible_characters < DialogueLength:
		await get_tree().process_frame
		if Input.is_action_pressed("second_button") and resource.can_be_skipped == true:
			DialogueRichText.visible_characters = DialogueLength
			break
		var delta = get_process_delta_time()
		visible_chars_float += resource.text_speed * delta
		var target_count: int = int(visible_chars_float)
		if target_count > DialogueRichText.visible_characters:
			target_count = min(target_count, DialogueLength)
			var chars_added = target_count - DialogueRichText.visible_characters
			if chars_added > 0:
				var character = clean_text_for_audio[DialogueRichText.visible_characters - 1]
				if character != " " and character != "*":
					$AudioStreamPlayer.pitch_scale = randf_range(resource.text_volume_pitch_min, resource.text_volume_pitch_max)
					$AudioStreamPlayer.play()
					if resource.speaker_img_hframes != 1:
						if SpeakerSprite.frame < resource.speaker_img_hframes - 1:
							SpeakerSprite.frame += 1
						else:
							SpeakerSprite.frame = 0
			DialogueRichText.visible_characters = target_count

	SpeakerSprite.frame = min(resource.speaker_img_rest_frame, resource.speaker_img_hframes - 1)

	while DialogueRichText.visible_characters != DialogueLength:
		await get_tree().process_frame
	return true


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
	for line: String in lines:
		if line.begins_with(">"):
			new_lines.append(line.replace(">", "  "))
		else:
			new_lines.append("* " + line)
	return "\n".join(new_lines)


func _process_tags(raw_text: String) -> String:
	var processed_text = raw_text
	var starting_point = processed_text.find("^")
	while starting_point != -1:
		var ending_point = starting_point
		while ending_point <= processed_text.length() - 1:
			var character = processed_text[ending_point]
			if INVALID_TAGS.find(character) != -1:
				break
			else:
				ending_point += 1
				#print(character)
		var fulltag: String = processed_text.substr(starting_point, ending_point - starting_point)
		var content = fulltag.remove_chars("^")
		var parts = content.split(".")

		var replacement_value: String = "err"

		if parts.size() >= 2:
			var tag_type = parts[0]
			if tag_type == "var":
				var node_path = parts[1]
				var variable_name = parts[2]
				var target_node = get_tree().root.get_node_or_null(node_path)
				if target_node:
					var value = target_node.get(variable_name)
					replacement_value = str(value)
				else:
					push_error("NODE NOT FOUND.")
			elif tag_type == "flag":
				var flag_name = parts[1]
				if GlobalVars.has_flag(flag_name):
					replacement_value = str(GlobalVars.get_flag(flag_name))
				else:
					replacement_value = "something went wrong"
		else:
			push_error("TAG IS NOT VALID.")

		processed_text = processed_text.replace(fulltag, replacement_value)
		starting_point = processed_text.find("^", starting_point + replacement_value.length())
	return processed_text
