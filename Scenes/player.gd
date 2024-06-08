extends CharacterBody2D

signal switching

@export var health : int
@export var balance : int
@export var item1 : Resource
@export var item2 : Resource
@export var item3 : Resource
var spawner
@export var Active_Item : Resource
@onready var vignette = preload("res://vignette.tscn")
@onready var _animation_player = $AnimationPlayer
#@onready var inventory = get_parent().get_node("CommandInput/CanvasLayer/InventoryGui")
@onready var inventory = get_node("InventoryGui")
@onready var isDead = false
@onready var randAnimRot = RandomNumberGenerator.new()
@export var SPEED = 450
var canShoot = false
var dirFace = 1
var can_toggle_pause = true
var hat_id : int

var randText : int
@onready var couldBuy = false
var tempItem : Resource
var cost : int
var spawnOneVin = true

# This file has gotten so long and it's probably unecessary, I am going to comment it to the best 
# of my ability O7

func _ready():
	# When player first created, set health to max, hat to zero, and properly update the rest of the player's stats
	hat_id = 0
	self.health = 10
	update_ammo_ui()
	update_health_ui()
	$HealthBar.max_value = self.health
	$statmenu.visible = false
	$hatmenu.visible = false
	print("My current scene is: ", get_tree().get_current_scene().get_name())
	# If in the hubworld, read the data from the Data to grab what is in the player's inventory
	if get_tree().get_current_scene().get_name() == "HubWorld":
		$EnemiesKilled.visible = false
		balance = Data.balance
		item1 = get_item_by_item_id(Data.item1_id)
		item2 = get_item_by_item_id(Data.item2_id)
		item3 = get_item_by_item_id(Data.item3_id)
		$Sprite2D/hat.texture = get_hat_by_hat_id(Data.hat_id)
		$Sprite2D/Weapon.visible = false
	# If in the main game, also grab what is in the player's inventory from Data
	else:
		print("Making it this far?")
		spawner = get_parent().get_node("EnemySpawner")
		balance = Data.balance
		item1 = get_item_by_item_id(Data.item1_id)
		item2 = get_item_by_item_id(Data.item2_id)
		item3 = get_item_by_item_id(Data.item3_id)
		$Sprite2D/hat.texture = get_hat_by_hat_id(Data.hat_id)
		$Sprite2D/Weapon.visible = true
		#Active_Item = item1
	# If an item comes back as null, set the item ID for the slot as zero
	if item1 == null:
		Data.item1_id = 0
	else:
		$InventoryGui/NinePatchRect/GridContainer/Slot/Contains.texture = item1.ITEM_TEXTURE
	if item2 == null:
		Data.item2_id = 0
	else:
		$InventoryGui/NinePatchRect/GridContainer/Slot2/Contains.texture = item2.ITEM_TEXTURE
	if item3 == null:
		Data.item3_id = 0
	else: 
		$InventoryGui/NinePatchRect/GridContainer/Slot3/Contains.texture = item3.ITEM_TEXTURE
	# If player's inventory is completely empty, give them the starting pistol in the first slot
	if Data.item3_id == 0 and Data.item2_id == 0 and Data.item1_id == 0 and get_tree().get_current_scene().get_name() == "HubWorld":
		item1 = load("res://Items/Repo/startingPistol.tres")
		Data.item1_id = item1.ITEM_ID
		$InventoryGui/NinePatchRect/GridContainer/Slot/Contains.texture = item1.ITEM_TEXTURE
		print(item1.ITEM_ID)
	item1.CURRENT_AMMO = item1.MAX_AMMO
	item2.CURRENT_AMMO = item2.MAX_AMMO
	item3.CURRENT_AMMO = item3.MAX_AMMO
	

# Should've just used a SQL db but I hate myself
func get_hat_by_hat_id(hatID : int) -> Texture2D:
	if hatID == 1:
		return load("res://Assets/mushroomhat.png")
	if hatID == 2:
		return load("res://Assets/sprout.png")
	if hatID == 3:
		return load("res://Assets/elfhat.png")
	if hatID == 4:
		return load("res://Assets/cowboy.png")
	if hatID == 5:
		return load("res://Assets/crown.png")
	if hatID == 6:
		return load("res://Assets/thechosenone.png")
	if hatID == 7:
		return load("res://Assets/theEye.png")
	else:
		return null

# Should've just used a SQL db but I hate myself part 2
func get_item_by_item_id(itemID : int) -> Resource:
	if itemID == 1:
		return load("res://Items/Repo/ak.tres")
	if itemID == 2:
		return load("res://Items/Repo/bowlingcannon.tres")
	if itemID == 3:
		return load("res://Items/Repo/fist.tres")
	if itemID == 4:
		return load("res://Items/Repo/kunai.tres")
	if itemID == 5:
		return load("res://Items/Repo/pea_shooter.tres")
	if itemID == 6:
		return load("res://Items/Repo/shotgun.tres")
	if itemID == 7:
		return load("res://Items/Repo/snubby.tres")
	if itemID == 8:
		return load("res://Items/Repo/watergun.tres")
	if itemID == 9:
		return load("res://Items/Repo/m4.tres")
	if itemID == 10:
		return load("res://Items/Repo/startingPistol.tres")
	if itemID == 11:
		return load("res://Items/Repo/doohickey.tres")
	else:
		return null
func update_health_ui():
	set_health_bar()

func update_ammo_ui():
	set_ammo_bar()

func set_ammo_bar():
	if Active_Item != null:
		# Update ammo UI according to the real value of the player's ammo
		$AmmoBar.max_value = Active_Item.MAX_AMMO
		$AmmoBar.value = Active_Item.MAX_AMMO - Active_Item.CURRENT_AMMO

func set_health_bar() -> void:
	#var progress_tween = get_tree().create_tween()
	#progress_tween.tween_property($HealthBar, "value", 10-health, 1.0).set_trans(Tween.TRANS_LINEAR)
	# set the health bar to what the player's real health is
	$HealthBar.value = 10-health

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if !isDead:
		if get_tree().get_current_scene().get_name() == "main":
			#if !spawner.canSpawnEnemies && spawnOneVin:
				#spawnOneVin = false
				#var vignetteInstance = vignette.instantiate()
				##vignetteInstance.get_child(0).position = position
				#add_child(vignetteInstance)
			# Update progress bar when in the main game
			$EnemiesKilled.visible = true
			$EnemiesKilled.max_value = spawner.enemiesUntilBoss
			$EnemiesKilled.value = spawner.enemyKillCount
			if !spawner.canSpawnEnemies:
				$EnemiesKilled.visible = false
		# Movement
		var direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
		# Function that lets the player pick a slot for the item they are trying to purchase
		if couldBuy:
			$hatmenu/HatmanSpeaking.text = "Which slot would you like this to go into? Type 1, 2, or 3"
			if Input.is_action_pressed("item_one"):
				Data.balance -= cost
				item1 = tempItem
				Data.item1 = item1
				Data.item1_id = item1.ITEM_ID
				$InventoryGui/NinePatchRect/GridContainer/Slot/Contains.texture = item1.ITEM_TEXTURE
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
			elif  Input.is_action_pressed("item_two"):
				Data.balance -= cost
				item2 = tempItem
				Data.item2 = item2
				Data.item2_id = item2.ITEM_ID
				$InventoryGui/NinePatchRect/GridContainer/Slot2/Contains.texture = item2.ITEM_TEXTURE
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
			elif  Input.is_action_pressed("item_three"):
				Data.balance -= cost
				item3 = tempItem
				Data.item3 = item3
				Data.item3_id = item3.ITEM_ID
				$InventoryGui/NinePatchRect/GridContainer/Slot3/Contains.texture = item3.ITEM_TEXTURE
				couldBuy = false
				$hatmenu/HatmanSpeaking.text = "Thank you for your purchase!"
		# Move the player
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
	# Collision detection for the player with it's environment
	@warning_ignore("unassigned_variable")
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
			get_tree().change_scene_to_file("res://Worlds/TestWorld.tscn")

			
func take_damage():
	deductHealth()
	print("PLAYER HP: ", health)
	check_death()
		
# Gets rid of duplicate collisions when enemies/projectiles get stuck in the player
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
		update_health_ui()
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
			get_tree().change_scene_to_file("res://Worlds/hub_world.tscn")

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


@warning_ignore("unused_parameter")
func _on_hatman_area_entered(area):
	# hehehehe
	print("I wanna fuck the hatman")
	# Give the hatman a random text blurb in his dialogue box
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

@warning_ignore("unused_parameter")
func _on_hatman_area_exited(area):
	# Close shop menu when leaving hitbox
	print("I don't wanna fuck the hatman")
	$hatmenu/ItemList.deselect_all()
	$hatmenu/ItemList2.deselect_all()
	couldBuy = false
	$hatmenu.visible = false


func _on_item_list_item_selected(index):
	# Hat purchasing logic
	if index == 0:
		if Data.balance >= 250:
			Data.balance -= 250
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/mushroomhat.png")
			Data.hat_id = 1
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 1:
		if Data.balance >= 1000:
			Data.balance -= 1000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/sprout.png")
			Data.hat_id = 2
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 2:
		if Data.balance >= 2000:
			Data.balance -= 2000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/elfhat.png")
			Data.hat_id = 3
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 3:
		if Data.balance >= 3000:
			Data.balance -= 3000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/cowboy.png")
			Data.hat_id = 3
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 4:
		if Data.balance >= 5000:
			Data.balance -= 5000
			$hatmenu/HatmanSpeaking.text = "Thank you for your business!"
			$Sprite2D/hat.texture = load("res://Assets/crown.png")
			Data.hat_id = 4
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 5:
		if Data.balance >= 7500:
			Data.balance -= 7500
			$hatmenu/HatmanSpeaking.text = "Be careful with this one, you don't want to know where I found it..."
			$Sprite2D/hat.texture = load("res://Assets/thechosenone.png")
			Data.hat_id = 5
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 6:
		if Data.balance >= 9999:
			Data.balance -= 9999
			$hatmenu/HatmanSpeaking.text = "Be careful with this one, you don't want to know where I found it..."
			$Sprite2D/hat.texture = load("res://Assets/theEye.png")
			Data.hat_id = 5
			Data.hat = $Sprite2D/hat.texture
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	
func _on_item_list_2_item_selected(index):
	# Gun purchasing logic
	print("Can buy 1?: ", couldBuy )
	print("Balance 1?: ", Data.balance )
	if index == 0:
		if Data.balance >= 70:
			couldBuy = true
			tempItem = load("res://Items/Repo/snubby.tres")
			cost = 70
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 1:
		if Data.balance >= 175:
			couldBuy = true
			tempItem = load("res://Items/Repo/ak.tres")
			cost = 175
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 2:
		if Data.balance >= 210:
			couldBuy = true
			tempItem = load("res://Items/Repo/m4.tres")
			cost = 210
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 3:
		print("Kunai!!!")
		if Data.balance >= 350:
			couldBuy = true
			tempItem = load("res://Items/Repo/kunai.tres")
			cost = 350
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 4:
		if Data.balance >= 700:
			couldBuy = true
			tempItem = load("res://Items/Repo/shotgun.tres")
			cost = 700
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 5:
		if Data.balance >= 1400:
			couldBuy = true
			tempItem = load("res://Items/Repo/doohickey.tres")
			cost = 1400
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 6:
		if Data.balance >= 3500:
			couldBuy = true
			tempItem = load("res://Items/Repo/watergun.tres")
			cost = 3500
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	if index == 7:
		if Data.balance >= 6969:
			couldBuy = true
			tempItem = load("res://Items/Repo/fist.tres")
			cost = 6969
		else:
			$hatmenu/HatmanSpeaking.text = "Looks like you need some more coins for this fine piece!"
	print("Can buy 2?: ", couldBuy )
	print("Balance 2?: ", balance )
	if (tempItem != null):
		print("Current temp gun: ", tempItem.ITEM_NAME)
	

# Menu visibility controllers
@warning_ignore("unused_parameter")
func _on_overseer_area_entered(area):
	if get_parent().get_node("overseer").visible:
		$statmenu.visible = true


@warning_ignore("unused_parameter")
func _on_overseer_area_exited(area):
	$statmenu.visible = false


@warning_ignore("unused_parameter")
func _on_knight_area_entered(area):
	if get_parent().get_node("knight").visible:
		$levelupgrademenu.visible = true


@warning_ignore("unused_parameter")
func _on_knight_area_exited(area):
	$levelupgrademenu.visible = false

# Buy spawning upgrades
func _on_texture_button_pressed():
	if Data.balance >= (250* (Data.spawningoffset+1)):
		Data.balance -= (250* (Data.spawningoffset+1))
		Data.spawningoffset += 1


func _on_value_button_pressed():
	if Data.balance >= (250* (Data.coinmultiplier+1)):
		Data.balance -= (250* (Data.coinmultiplier+1))
		Data.coinmultiplier += 1
