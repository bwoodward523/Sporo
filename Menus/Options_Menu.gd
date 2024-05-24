extends Control

var center : Vector2
@onready var node = $Control

func _ready():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

func _process(delta):
	var tween = node.create_tween()
	var offset =  (center - get_global_mouse_position()) * 0.2
	tween.tween_property(node, "position", offset, 1.0)

func _on_item_rect_changed():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	
	if node != null:
		node.global_position = center

func _on_back_to_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/Menu.tscn")




func _on_volume_pressed():
	if($MarginContainer/VBoxContainer/Volumebox.visible):
		$MarginContainer/VBoxContainer/Volumebox.visible = false
	else:
		$MarginContainer/VBoxContainer/Volumebox.visible = true


func _on_sfx_volume_drag_ended(value_changed):
	$hurttest.play()



func _on_fullscreen_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_windowed_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
