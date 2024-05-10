extends Node2D

@onready var main = get_tree().get_root().get_node("main")
@onready var playerProjectile = load("res://Scenes/projectile.tscn")
#
#func _ready():
	#playerShoot()
#func playerShoot():
	#var instance = playerProjectile.instantiate()
	#instance.dir = rotation
	#instance.spawnPos = global_position
	#instance.spawnRot = rotation
	#main.add_child(instance)
	#print("Hi")
	#
