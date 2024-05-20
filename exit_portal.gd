extends Area2D



func _on_area_entered(area):
	print("is entered")
	if area.is_in_group("playergroup"): 
		get_tree().change_scene_to_file("res://hub_world.tscn")


func _on_body_entered(body):
	if body.is_in_group("playergroup"): 
		get_tree().change_scene_to_file("res://hub_world.tscn")
