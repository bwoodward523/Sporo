extends Node2D

@onready var player = $player

func _ready():
	# Check to see if playing is attempting to go into the main game
	player.switching.connect(switch_scene)
	# Check to see if NPC requirements have been met
	if Data.liches > 0:
		$overseer.visible = true
	if (Data.liches+Data.bats+Data.grunts+Data.summoners+Data.gnomes+Data.mages) >= 2000:
		$knight.visible = true
	if (Data.liches+Data.bats+Data.grunts+Data.summoners+Data.gnomes+Data.mages) >= 1:
		$hatman.visible = true
func _process(delta):
	# processing for pause game
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$player/Node2D/VBoxContainer.visible = true
		else:
			$player/Node2D/VBoxContainer.visible = false

func switch_scene():
	$TransitionScreen/AnimationPlayer.play("fade_to_black")
	get_tree().change_scene_to_file("res://Worlds/TestWorld.tscn")






func _on_texture_button_pressed():
	# Resume game
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false


func _on_texture_button_2_pressed():
	# Return player to main menu
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false
	Data.save()
	get_tree().change_scene_to_file("res://Menus/Menu.tscn")
