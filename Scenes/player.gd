extends CharacterBody2D
const SPEED = 450
var canShoot = false
var dirFace = 1
func _physics_process(delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")


	canShoot = Input.is_action_just_pressed("shoot")
	if(canShoot):
		print("WooHoo we shootin")
	
	var transform1= $Rifle.get_transform()
	velocity = direction * SPEED
	if direction:
		if velocity.x > 0:
			#$CharacterBody2D.set_scale
			print("we move right")
			#scale.x = scale*-1.0
			#$Rifle.move_local_x(-transform1, true)
		elif velocity.x < 0:
			print("we move left")
			#$Sprite2D.flip_h = false
			#scale.x = 1
			#$Rifle.move_local_x(transform1, true)
	
	move_and_slide()
	pass
	
