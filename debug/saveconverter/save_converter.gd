extends Node2D

func _ready() -> void:
	var save_dict = SaveManager.load_game()
	print(save_dict)
	SaveManager.load_save_to_global(save_dict)
	SaveManager.save_game(false, true)
