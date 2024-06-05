extends Node2D
@onready var raindrop = load("res://raindrop.tscn")


@warning_ignore("unused_parameter")
func _process(delta):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$player/Node2D/VBoxContainer.visible = true
		else:
			$player/Node2D/VBoxContainer.visible = false
	#for i in 5:
		#if rng.randi_range(1, 2) == 2:
			#var instance = raindrop.instantiate()
			#var randWidth = rng.randi_range(player.position.x - screenWidth.x/2, player.position.x + screenWidth.x/2)
			#instance.position = Vector2(randWidth, player.position.y - screenWidth.y/2)
			#add_child(instance)
	
func _on_texture_button_pressed():
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false

func _on_texture_button_2_pressed():
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false
	Data.save()
	get_tree().change_scene_to_file("res://Menus/Menu.tscn")
