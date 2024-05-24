extends Area2D



func _on_area_entered(area):
	print(area.name)
	if area.name.contains("forexit"):
		get_tree().change_scene_to_file("res://Worlds/hub_world.tscn")


func _on_timer_timeout():
	$TransitionScreen/AnimationPlayer.play("fade_to_black")
	$AnimationPlayer.play("spinIn")
