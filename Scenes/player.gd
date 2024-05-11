extends CharacterBody2D

@onready var playerProjectile = load("res://Scenes/projectile.tscn")
@onready var main = get_tree().get_current_scene()

@onready var _animation_player = $AnimationPlayer
const SPEED = 450
var canShoot = false
var dirFace = 1


func _ready():
	$HealthComponent.health = 10
	
func _physics_process(delta):
	print($HealthComponent.health)
	
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")


	canShoot = Input.is_action_pressed("shoot")
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().change_scene_to_file("res://Menu.tscn")
	if(canShoot):
		playerShoot()
	
	velocity = direction * SPEED
	
	if Input.is_action_pressed("moveRight"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = false
		$Sprite2D/Rifle.flip_h = true
	elif Input.is_action_pressed("moveLeft"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = true
		$Sprite2D/Rifle.flip_h = false
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
	pass
	
func playerShoot():
	var instance = playerProjectile.instantiate()
	var bulletDirection = (get_global_mouse_position() - position).normalized()
	instance.dir = bulletDirection
	instance.spawnPos = Vector2(global_position.x, global_position.y)
	instance.spawnRot = rotation
	instance.zdex = z_index -1
	main.add_child(instance)
	


func _on_area_2d_body_entered(body):
	print(body.name)
	if body.name.contains("Enemy"):
		$HealthComponent.deductHealth()
		if $HealthComponent.isDead:
			queue_free()
	
