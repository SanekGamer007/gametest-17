extends Node

func _ready() -> void:
	get_window().borderless = false
	if OS.has_feature("editor"):
		_get_commit_hash()
	Tools.change_window_title(" ")
	SaveManager.load_sys_info_to_global(SaveManager.load_system_information())
	if OS.is_debug_build():
		var iii: PackedScene = load("res://debug/debug_menu/debug.tscn")
		var iiii: PackedScene = load("res://debug/overlay/debug_build_overlay.tscn")
		var i2 = iii.instantiate()
		var i4 = iiii.instantiate()
		get_tree().root.add_child.call_deferred(i2)
		get_tree().root.add_child.call_deferred(i4)
	if GlobalVars.has_beaten_demo == true:
		SceneManager.change_scene("res://levels/menu/real_intro/real_intro.tscn", "A", "none")
	else:
		SceneManager.change_scene("res://levels/menu/fake_title/fake_title.tscn", "A", "none")

func _get_commit_hash() -> void:
	var out: Array[String]
	var exit_code = OS.execute("git", ["rev-parse", "--short", "HEAD"], out)
	
	if exit_code == 0:
		var commit = out[0].strip_edges()
		var file = FileAccess.open("res://commit.txt", FileAccess.WRITE)
		print(commit)
		
		file.store_string(commit)
		file.close()
	else:
		print_debug("Git repo not found.")
