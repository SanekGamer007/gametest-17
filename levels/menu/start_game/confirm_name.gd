extends Control

var player_name: String

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("second_button"):
		if visible:
			_on_no_pressed()
			get_viewport().set_input_as_handled()

func prep() -> void:
	$HBoxContainer/No.text = "No"
	$HBoxContainer/Yes.disabled = false
	$HBoxContainer/Yes.visible = true
	$PlayerName.text = "[shake shake rate=22.0 level 8] " + player_name
	$AnimationPlayer.play("bigger_and_better_big_shot_boss")
	match player_name.to_upper():
		"TORIEL":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "A lonely mother."
		"SNK", "SNKZ", "SNKZE", "SNKZER", "SNKZERO":
			_disable_confirmation()
			var randnum = randi_range(0, 2)
			if randnum == 0:
				$VBoxContainer/HBoxContainer/Label.text = "Be more original."
			elif randnum == 1:
				$VBoxContainer/HBoxContainer/Label.text = "Cmon, you can pick something\nbetter."
			else:
				var sysinfo: Dictionary = SaveManager.load_system_information()
				if sysinfo.get("has_beaten_demo", false) == true:
					$VBoxContainer/HBoxContainer/Label.text = "You cannot use the\ndev's name."
				else:
					$VBoxContainer/HBoxContainer/Label.text = "This name is off limits."
		"TOBY", "TOBYFOX":
			$VBoxContainer/HBoxContainer/Label.text = "... is not a god in this\nuniverse."
		"GAMETEST":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = ""
		"ALPHYS", "ALPHY":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "You hear nothing but wind roaring."
		"METTATON", "METTATO", "METTAT", "METTA", "MTT":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "Nothing but an idea inside of\nsomeone, gone long ago."
		"ASGORE":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "Just a husk of someone far greater."
		"ASRIEL":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "..."
		"FLOWEY":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "That's MY name\nyou CANNOT choose that."
		"SANS":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "sorry kid"
		"UNDYNE":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "A sad, sad fish in a big, big sea."
		"FRISK":
			$VBoxContainer/HBoxContainer/Label.text = ""
		"MURDER", "MERCY":
			$VBoxContainer/HBoxContainer/Label.text = "Interesting."
		"CHARA":
			$VBoxContainer/HBoxContainer/Label.text = "Not even surprised."
		"A", "AA", "AAAAAA", "AAAAAAAA":
			$VBoxContainer/HBoxContainer/Label.text = "Not very creative today, huh?"
		"JERRY":
			$VBoxContainer/HBoxContainer/Label.text = "Freak."
		"GERSON":
			$VBoxContainer/HBoxContainer/Label.text = "Wah ha ha! Why not?"
		"NAPSTA", "BLOOKY":
			$VBoxContainer/HBoxContainer/Label.text = "They won't stop you."
		"PAPYRU", "PAPS", "PAPYRUS":
			_disable_confirmation()
			$VBoxContainer/HBoxContainer/Label.text = "NO!!! ONLY I\nTHE GREAT PAPYRUS\nCAN USE THAT NAME!!!!"
		"SHYREN":
			$VBoxContainer/HBoxContainer/Label.text = "...?"
		"TEMMIE":
			$VBoxContainer/HBoxContainer/Label.text = "hOI!"
		_:
			$VBoxContainer/HBoxContainer/Label.text = "Is this name correct?"
		
func _on_no_pressed() -> void:
	$AnimationPlayer.play("RESET")
	owner.go_back_to_pick()


func _on_yes_pressed() -> void:
	$HBoxContainer/Yes.release_focus()
	owner.the_choice_has_been_made()

func _disable_confirmation() -> void:
	$HBoxContainer/Yes.disabled = true
	$HBoxContainer/Yes.visible = false
	$HBoxContainer/No.text = "Go back."
