extends CharacterBody2D

@export var enemy: Resource
@onready var main = get_node("/root/main")
@onready var player = get_parent().get_node("player")
var isDead =  false
var addDeathTimer = true
@onready var spawner = get_parent().get_node("EnemySpawner")
var item_scene := preload("res://Scenes/coin.tscn")
@onready var bullet1 = enemy.PROJECTILE_TYPE[0]
@onready var enemyScene = preload("res://Enemies/Scenes/enemy_gnome.tscn")
@onready var enemySpawner = get_parent().get_node("EnemySpawner")
var behaviorState = "Searching"
var isHurt: bool
@onready var detectionRange = enemy.ENEMY_DETECTION_RANGE
@export var fleeRange: float
var fromParentGnome = false
var canMultiply = false
var shotCount = 0
var doOnce = true
@export var shotsUntilMultiply: int
var randomDirFunny
var rng = RandomNumberGenerator.new()
@export var bullSprite: Texture2D

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	$HealthComponent.health = enemy.ENEMY_HEALTH
	rng = RandomNumberGenerator.new()
	rng.randomize()
	randomDirFunny= Vector2(rng.randi_range(-30,30), rng.randi_range(-30,30))

func _physics_process(delta):
	if spawner.bandaidNoMoreBoss && addDeathTimer:
		addDeathTimer = false
		$BossKill.start(1)
	$Sprite2D.visible = true
	manage_states()
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	if behaviorState == "Searching":
		velocity = (player.position - position).normalized() * enemy.ENEMY_SPEED
		move_and_collide(velocity * delta)
		$FireRate.stop()
	if behaviorState == "Attacking":
		#enable timer cooldown
		velocity = randomDirFunny.normalized() * enemy.ENEMY_SPEED 
		move_and_collide(velocity * delta)
		if $FireRate.time_left == 0:
			$FireRate.start()
	
	if behaviorState == "Fleeing":
		#opposite direction from searching
		velocity = (-(player.position - position).normalized()) * enemy.ENEMY_SPEED
		move_and_collide(velocity * delta)

	if canMultiply:
		multiply_self()
		

	if $HealthComponent.isDead:
		death()
func drop_heart():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 1
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func drop_item():
	var item = item_scene.instantiate()
	item.item_type = 0
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func death():
	if doOnce:
		isDead = true
		#print("popped gnome")
		spawner.enemyKillCount += 1
		if randi_range(0,3) == 2:
			drop_item()
		if randi_range(0, 100) == 69: #hehehe
			drop_heart()
		if rng.randi_range(1,2) == 2:
			scale.x = -scale.x
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("gnomeDeath")
		$AnimationPlayer.clear_queue()
		$CollisionShape2D.disabled = true
		doOnce = false
		if randi_range(0, 50) == 21: #hehehe
				drop_ammo()
func drop_ammo():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 2
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func take_damage():
	$HealthComponent.deductHealth()
	rng.randomize()
	if rng.randi_range(1,2) == 2:
		$AnimationPlayer.play("gnomeHurt1")	
	else:
		$AnimationPlayer.play("gnomeHurt2")
func shoot():
	var bulletInstance = bullet1.instantiate()
	bulletInstance.position = position
	bulletInstance.dir = (player.position - position).normalized()
	bulletInstance.sprite1 = bullSprite
	#bulletInstance.rotation = position.angle_to_point(player.global_position)
	get_parent().add_child(bulletInstance)
func _play_hurt():
	pass

func manage_states():
	if position.distance_to(player.position) <= detectionRange:
		behaviorState = "Attacking"
		if position.distance_to(player.position) <= fleeRange:
			behaviorState = "Fleeing"
	else:
		behaviorState = "Searching"
func attack():
	velocity = Vector2(0,0)
func _on_fire_rate_timeout():
	shoot()
	shotCount+= 1
	

func multiply_self():
	canMultiply = false
	var enemyGnomeInstance = enemyScene.instantiate()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	enemyGnomeInstance.position = Vector2(position.x + rng.randi_range(-20,20) , position.y +rng.randi_range(-20,20))
	enemyGnomeInstance.fromParentGnome = true
	enemyGnomeInstance.z_index = z_index -1

	get_parent().add_child(enemyGnomeInstance, true)
	




func _on_time_to_multiply_timeout():
	if enemySpawner.canSpawnGnome:
		if behaviorState == "Attacking" or behaviorState == "Fleeing":
			canMultiply = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "gnomeDeath":
		queue_free()


func _on_boss_kill_timeout():
	$AnimationPlayer.play("gnomeDeath")
