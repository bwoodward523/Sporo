extends CharacterBody2D

signal switching

@export var balance : int
@export var item1 : Resource
@export var item2 : Resource
@export var item3 : Resource
@export var Active_Item : Resource


@onready var _animation_player = $AnimationPlayer
#@onready var inventory = get_parent().get_node("CommandInput/CanvasLayer/InventoryGui")
@onready var inventory = get_node("InventoryGui")

@export var SPEED = 450
var canShoot = false
var dirFace = 1



func _physics_process(delta):
	var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().change_scene_to_file("res://Menu.tscn")
	
	
	velocity = direction * SPEED
	
	if Input.is_action_pressed("moveRight"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = false

	elif Input.is_action_pressed("moveLeft"):
		_animation_player.play("walk")
		$Sprite2D.flip_h = true
	elif Input.is_action_pressed("moveDown"):
		_animation_player.play("walk")
	elif Input.is_action_pressed("moveUp"):
		_animation_player.play("walk")
	else:
		_animation_player.play("RESET")
	if direction:
		if velocity.x > 0:
			pass

		elif velocity.x < 0:
			pass

	
	move_and_slide()
	
	detect_enemy()
	pass
	

func detect_enemy():
	
	var collisionList: Array
	#make array of all names of collisions
	for i in get_slide_collision_count():
		collisionList.append(get_slide_collision(i).get_collider().name)
		
	var collisionListNames = delete_duplicate_collisions(collisionList)
	for i in collisionListNames:
		print("I collided with: ", i)
		#Check to see if we collided with an enemy
		if i.contains("Enemy"):
			for k in get_slide_collision_count():
				var collision = get_slide_collision(k)
				if collision.get_collider().has_method("take_damage"):
					#collision.get_collider().take_damage()
					collision.get_collider().queue_free()
					#play collision explosion anim or something 
				else:
					print("implement take_damage function on player collision")
				
			$HealthComponent.deductHealth()
			print("PLAYER HP: ", $HealthComponent.health)
			#Check if player is dead
			check_death()
		if i.contains("levelswitch"):
			emit_signal("switching")

			
func take_damage():
	$HealthComponent.deductHealth()
	print("PLAYER HP: ", $HealthComponent.health)
	check_death()
		
func delete_duplicate_collisions(collisions: Array):
	var unique: Array = []
	for item in collisions:
		if !unique.has(item):
			unique.append(item)
	return unique

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()

func check_death():
	if $HealthComponent.isDead:
		visible = false
		print($HealthComponent.isDead)
		if is_inside_tree():
			get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")


