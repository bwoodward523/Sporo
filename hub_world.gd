extends Node2D

@onready var player = $player

func _process(delta):
	player.switching.connect(switch_scene)

func switch_scene():
	$TransitionScreen/AnimationPlayer.play("fade_to_black")
	get_tree().change_scene_to_file("res://TestWorld.tscn")
