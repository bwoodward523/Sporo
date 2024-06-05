extends Control

var center : Vector2
@onready var node = $Control

func _ready():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

@warning_ignore("unused_parameter")
func _process(delta):
	var tween = node.create_tween()
	var offset = (center - get_global_mouse_position()) * 0.2
	tween.tween_property(node, "position", offset, 1.0)

func _on_item_rect_changed():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	
	if node != null:
		node.global_position = center

func _on_play_pressed():
	$MarginContainer/VBoxContainer/StartNewConfirm.visible = !$MarginContainer/VBoxContainer/StartNewConfirm.visible



func _on_options_pressed():
	get_tree().change_scene_to_file("res://Menus/Options_Menu.tscn")



func _on_exit_pressed():
	Data.save()
	get_tree().quit()


func _on_load_game_pressed():
	$MarginContainer/VBoxContainer/LoadConfirm.visible = !$MarginContainer/VBoxContainer/LoadConfirm.visible


func _on_yes_pressed():
	Data.load_data()
	get_tree().change_scene_to_file("res://Worlds/hub_world.tscn")


func _on_no_pressed():
	$MarginContainer/VBoxContainer/LoadConfirm.visible = false


func _on_new_yes_pressed():
	get_tree().change_scene_to_file("res://Worlds/hub_world.tscn")


func _on_new_no_pressed():
	$MarginContainer/VBoxContainer/LoadConfirm.visible = false
