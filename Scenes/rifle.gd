extends CharacterBody2D
@onready var playerProjectile = load("res://Scenes/projectile.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_parent()
@onready var barrel = get_node("Rifle/Barrel")


func _physics_process(delta):
	
	if Input.is_action_pressed("shoot"):
		playerShoot()
	#rotate gun towards mouse
	look_at(get_global_mouse_position())
	print(rotation_degrees)
	
	if abs(rotation_degrees) >= 90: #This kinda works. goal is for gun to face a dir that feels right
		$Rifle.flip_v = true
	else:
		$Rifle.flip_v = false
		
	if abs(rotation_degrees) >= 180:
		rotation_degrees *= -1


func playerShoot():
	var instance = playerProjectile.instantiate()
	var bulletDirection = (get_global_mouse_position() - player.position).normalized()
	instance.dir = bulletDirection
	instance.spawnPos = Vector2(barrel.global_position.x, barrel.global_position.y)
	instance.spawnRot = rotation
	instance.zdex = z_index -1
	main.add_child(instance)
