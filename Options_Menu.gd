extends Control



func _on_back_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")





func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
