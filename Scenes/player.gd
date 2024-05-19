extends CharacterBody2D

signal switching

@export var health : int
@export var balance : int
@export var item1 : Resource
@export var item2 : Resource
@export var item3 : Resource
@export var Active_Item : Resource

@onready var spawner = get_parent().get_node("EnemySpawner")
@onready var _animation_player = $AnimationPlayer
#@onready var inventory = get_parent().get_node("CommandInput/CanvasLayer/InventoryGui")
@onready var inventory = get_node("InventoryGui")
@onready var isDead = false
@onready var randAnimRot = RandomNumberGenerator.new()
@export var SPEED = 450
var canShoot = false
var dirFace = 1
var can_toggle_pause = true

var randText : int
@onready var couldBuy = false
var tempItem : Resource
var cost : int

func _ready():
	self.health = 10
	$hatmenu.visible = false
	print("My current scene is: ", get_tree().get_current_scene().get_name())
	if get_tree().get_current_scene().get_name() == "HubWorld":
		$EnemiesKilled.visible = false
		
		if Data.item1 != null:
			item1 = Data.item1
		if Data.item2 != null:
			item2 = Data.item2
		if Data.item3 != null:
			item3 = Data.item3
		if Data.hat != null:
			$Sprite2D/hat.texture = Data.hat
	else:
		if item1 != null:
			item1 = Data.item1
		if item2 != null:
			item2 = Data.item2
		if item3 != null:
			item3 = Data.item3
		if Data.hat != null:
			$Sprite2D/hat.texture = Data.hat

func _physics_process(delta):
	if !isDead:
		if get_tree().get_current_scene().get_name() == "main":
			$EnemiesKilled.visible = true
			$EnemiesKilled.max_value = spawner.enemiesUntilBoss
			$EnemiesKilled.value = spawner.enemyKillCount
			if !spawner.canSpawnEnemies:
				$EnemiesKilled.visible = false
		var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		if couldBuy:
			$hatmenu/HatmanSpeaking.text = "Which slot would you like this to go into? Type 1, 2, or 3"
			if Input.is_action_pressed("item_one"):
				balance -= cost
				item1 = tempItem
				Data.item1 = item1
				print("Did it work (should be shotgun): ", item1)
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
			elif  Input.is_action_pressed("item_two"):
				balance -= cost
				item2 = tempItem
				Data.item2 = item2
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
			elif  Input.is_action_pressed("item_three"):
				balance -= cost
				item3 = tempItem
				Data.item3 = item3
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
		
		velocity = direction * SPEED
		
		if Input.is_action_pressed("moveRight"):
			_animation_player.play("walk")
			$Sprite2D.flip_h = true

		elif Input.is_action_pressed("moveLeft"):
			_animation_player.play("walk")
			$Sprite2D.flip_h = false
		elif Input.is_action_pressed("moveDown"):
			_animation_player.play("walk")
		elif Input.is_action_pressed("moveUp"):
			_animation_player.play("walk")
		else:
			_animation_player.play("RESET")
			
		move_and_slide()
		
		detect_enemy()
		pass
	else:
		_animation_player.play("RESET")	

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
					if !i.contains("EnemyBoss"):
						collision.get_collider().queue_free()
					#play collision explosion anim or something 
				else:
					print("implement take_damage function on player collision")
				
			deductHealth()
			print("PLAYER HP: ", health)
			#Check if player is dead
			check_death()
		if i.contains("levelswitch"):
			emit_signal("switching")

			
func take_damage():
	deductHealth()
	print("PLAYER HP: ", health)
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
	#if event.is_action_pressed("pause"):
		#pausedMenu()

func deductHealth():
	if !isDead:
		health -= 1
		randAnimRot.randomize()
		var hurtAnim = $HurtAndDeathAnimation.get_animation("playerHurt")
		hurtAnim.track_set_key_value(1, 1, deg_to_rad(randAnimRot.randf_range(-50,50)))
		$HurtAndDeathAnimation.play("playerHurt")
		$AudioStreamPlayer2D.play()
		if health <= 0:
			isDead = true
			$CollisionShape2D.disabled = true
			$Area2D/CollisionShape2D.disabled =true
			$Area2D.monitoring = false
			$Area2D.monitorable = false

func _on_hurt_and_death_animation_animation_finished(anim_name):
	if anim_name == "playerDeath":
		if is_inside_tree():
			get_tree().change_scene_to_file("res://hub_world.tscn")

func check_death():
	if isDead:
		$HurtAndDeathAnimation.clear_queue()
		$HurtAndDeathAnimation.play("playerDeath")
		print(isDead)
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("enemyBullet"):
		take_damage()
		print("gotBullets?")
		area.queue_free()


func _on_hatman_area_entered(area):
	print("I wanna fuck the hatman")
	randText = randi_range(0, 100)
	if randText < 16:
		$hatmenu/HatmanSpeaking.text = "Welcome to my shop! I hope you'll find everything you need before venturing into the cave!"
	elif randText < 32:
		$hatmenu/HatmanSpeaking.text = "The evil forest is no place for the faint of heart. Stock up on supplies before you go!"
	elif randText < 48:
		$hatmenu/HatmanSpeaking.text = "Good luck out there, brave mushroom. May the forest spirits watch over you."
	elif randText < 64:
		$hatmenu/HatmanSpeaking.text = "Beware of the shadows in that forest. Many have entered, but few have returned."
	elif randText < 80:
		$hatmenu/HatmanSpeaking.text = "I've seen many little mushrooms come and go. You, my friend, have a spark of hope."
	elif randText < 99:
		$hatmenu/HatmanSpeaking.text = "Those roots of yours need protection. How about a sturdy helmet?"
	else:
		$hatmenu/HatmanSpeaking.text = "I'm dying, little mushroom. The spores have pierced my heart and I don't have much longer. Please kill the forest wraith and save my soul"
	$hatmenu.visible = true

func _on_hatman_area_exited(area):
	print("I don't wanna fuck the hatman")
	$hatmenu/ItemList.deselect_all()
	$hatmenu/ItemList2.deselect_all()
	couldBuy = false
	$hatmenu.visible = false


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	if index == 0:
		if balance >= 250:
			balance -= 250
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/mushroomhat.png")
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 1:
		if balance >= 1000:
			balance -= 1000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/sprout.png")
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 2:
		if balance >= 3000:
			balance -= 3000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/cowboy.png")
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 3:
		if balance >= 5000:
			balance -= 5000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/crown.png")
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 4:
		if balance >= 9999:
			balance -= 9999
			$hatmenu/HatmanSpeaking.text = "Be careful with this one, you don't want to know where I found it..."
			$Sprite2D/hat.texture = load("res://Assets/theEye.png")
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	
func _on_item_list_2_item_selected(index):
	print("Can buy 1?: ", couldBuy )
	print("Balance 1?: ", balance )
	if index == 0:
		if balance >= 100:
			couldBuy = true
			tempItem = load("res://Items/Repo/snubby.tres")
			cost = 100
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 1:
		if balance >= 250:
			couldBuy = true
			tempItem = load("res://Items/Repo/ak.tres")
			cost = 1000
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 2:
		if balance >= 1000:
			couldBuy = true
			tempItem = load("res://Items/Repo/kunai.tres")
			cost = 1000
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 3:
		if balance >= 1000:
			couldBuy = true
			tempItem = load("res://Items/Repo/shotgun.tres")
			cost = 1000
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 4:
		if balance >= 5000:
			couldBuy = true
			tempItem = load("res://Items/Repo/watergun.tres")
			cost = 5000
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	print("Can buy 2?: ", couldBuy )
	print("Balance 2?: ", balance )
	print("Current temp gun: ", tempItem.ITEM_NAME)
	



