extends Control

var return_location: String = "res://levels/menu/real_title/real_title.tscn" # if we come from fake_title then we just override it.
var default_name: String = "Chara" # if something goes wrong we default to chara =)



func real_title_ready() -> void:
	$NamePicker/GridContainer.get_child(0).grab_focus() # race condition but pffft who cares my game my rules.


func fake_title_ready() -> void:
	return_location = "res://levels/menu/fake_title/fake_title.tscn"
	$NamePicker/GridContainer.get_child(0).grab_focus()

func name_chosen(player_name: String) -> void:
	GlobalVars.player_name = player_name
	if player_name.is_empty():
		player_name = default_name
	$ConfirmName.player_name = player_name
	$NamePicker.visible = false
	$ConfirmName.visible = true
	$ConfirmName/HBoxContainer/No.grab_focus()
	$ConfirmName.prep()

func go_back_to_pick() -> void:
	$ConfirmName.visible = false
	$NamePicker.visible = true
	$NamePicker/GridContainer.get_child(0).grab_focus()

func the_choice_has_been_made() -> void:
	GlobalVars.load_time = Time.get_ticks_msec()
	GlobalVars.true_reset_count += 1
	$WhiteFader.play("fade")
	await $WhiteFader.animation_finished
	SceneManager.change_scene("res://levels/test_level.tscn", "A", "none")
