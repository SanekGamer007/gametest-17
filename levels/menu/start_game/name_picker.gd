extends Control
# half of the code is stolen from here: https://www.youtube.com/watch?v=2wLdbB-Xpbg
var player_name: String
const CharButton = preload("res://levels/menu/start_game/char_button/char_button.tscn")

var characters: Array[String] = [
	"A", "B", "C", "D", "E", "F", "G",
	"H", "I", "J", "K", "L", "M", "N",
	"O", "P", "Q", "R", "S", "T", "U",
	"V", "W", "X", "Y", "Z", "", "",

	"a", "b", "c", "d", "e", "f", "g",
	"h", "i", "j", "k", "l", "m", "n",
	"o", "p", "q", "r", "s", "t", "u",
	"v", "w", "x", "y", "z", "", ""
]

func _ready() -> void:
	var prev_button: Button
	for i in characters.size():
		var char_button: Button = CharButton.instantiate()
		char_button.text = characters[i]
		char_button.self_modulate.a = 0.0
		char_button.get_child(0).text = "[shake shake rate=22.0 level 8]" + characters[i]
		if characters[i] == "":
			char_button.disabled = true
			char_button.focus_mode = Control.FOCUS_NONE
			
		char_button.pressed.connect(char_button_pressed.bind(characters[i]))
		$GridContainer.add_child(char_button, true)
		if i >= 50: # really ugly workaround but i cant think of anything else to fix that issue.
			prev_button.focus_neighbor_right = char_button.get_path()
			if char_button.text != "v":
				char_button.focus_neighbor_left = prev_button.get_path()
		prev_button = char_button

func char_button_pressed(text: String) -> void:
	if player_name.length() >= 8:
		player_name[7] = text
	else:
		player_name += text
	match player_name.to_upper():
		"GASTER":
			get_tree().quit()
			return
	$PlayerName.text = player_name


func _on_quit_pressed() -> void:
	SceneManager.change_scene(owner.return_location, "A", "none")


func _on_backspace_pressed() -> void:
	if player_name.length() > 0:
		player_name = player_name.left(-1)
	$PlayerName.text = player_name


func _on_done_pressed() -> void:
	if player_name != "":
		owner.name_chosen(player_name)
