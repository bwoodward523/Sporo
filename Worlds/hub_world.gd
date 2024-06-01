extends Node2D

@onready var player = $player

func _ready():
	player.switching.connect(switch_scene)
	if Data.liches > 0:
		$overseer.visible = true
func _process(delta):
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
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false


func _on_texture_button_2_pressed():
	get_tree().paused = false
	$player/Node2D/VBoxContainer.visible = false
	Data.save()
	get_tree().change_scene_to_file("res://Menus/Menu.tscn")
