extends CharacterBody2D



@onready var _animation_player = $AnimationPlayer
@export var SPEED = 450
var canShoot = false
var dirFace = 1


func _ready():
	pass
	
func _physics_process(delta):
	#print($HealthComponent.health)
	
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")

	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().change_scene_to_file("res://Menu.tscn")
	
	
	velocity = direction * SPEED
	
	if Input.is_action_pressed("moveRight"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = false
	#if Input.is_action_just_pressed("moveRight"):
		#$Sprite2D/Rifle.position.x *= -1
	elif Input.is_action_pressed("moveLeft"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = true
	#if Input.is_action_just_pressed("moveLeft"):
		#$Sprite2D/Rifle.position.x *= -1
	else:
		_animation_player.play("RESET")
	if direction:
		if velocity.x > 0:
			pass
			#print("we move right")
		elif velocity.x < 0:
			pass
			#print("we move left")
	
	move_and_slide()
	detectEnemy()
	pass
	
#func playerShoot():
	#var instance = playerProjectile.instantiate()
	#var bulletDirection = (get_global_mouse_position() - position).normalized()
	#instance.dir = bulletDirection
	#instance.spawnPos = Vector2(global_position.x, global_position.y)
	#instance.spawnRot = rotation
	#instance.zdex = z_index -1
	#main.add_child(instance)
	

func detectEnemy():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("I collided with: ", collision.get_collider().name)
		#Check to see if we collided with an enemy
		if collision.get_collider().name.contains("Enemy"):
			collision.get_collider().queue_free()
			$HealthComponent.deductHealth()
			print("PLAYER HP: ", $HealthComponent.health)
			#Check if player is dead
			checkDeath()
			

func checkDeath():
	if $HealthComponent.isDead:
		visible = false


