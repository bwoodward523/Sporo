extends CharacterBody2D

@export var enemy: Resource
var item_scene := preload("res://Scenes/coin.tscn")
@onready var bat = preload("res://Enemies/Scenes/BatBullet.tscn")
@onready var spawner = get_parent().get_node("EnemySpawner")

@onready var deathTimer = preload("res://Enemies/add_death_timer.gd").new()
var addDeathTimer = true
@onready var player = get_parent().get_node("player")
@onready var main = get_parent()
var isHurt: bool
var worldBatCount: int
@export var maxBatsInWorld: int
var doDeath = true
var rng = RandomNumberGenerator.new()
var justSummoned = false
var startFleeTimer = true
func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	$HealthComponent.health = enemy.ENEMY_HEALTH
func _physics_process(delta):
	if justSummoned:
		velocity = -(player.position - position).normalized() * enemy.ENEMY_SPEED * delta
		if startFleeTimer:
			startFleeTimer = false
	else:
		velocity = (player.position - position).normalized() * enemy.ENEMY_SPEED * delta
	move_and_slide()
	
	if spawner.bandaidNoMoreBoss && addDeathTimer:
		addDeathTimer = false
		$BossKill.start(1)

func death():
	if doDeath:
		doDeath = false
		
		rng.randomize()
		if randi_range(0,3) == 2:
			drop_item()
		if randi_range(0, 100) == 69: #hehehe
			drop_heart()
		if randi_range(0, 50) == 21: #hehehe
				drop_ammo()
		if rng.randi_range(1,2) == 2:
			scale.x = -scale.x
	$AudioStreamPlayer2D.play()
	$AnimationPlayer.clear_queue()
	$AnimationPlayer.play("summonerDeath")
	$CollisionShape2D.disabled = true
	$AreaHurtBox/CollisionShape2D.disabled =true
func drop_ammo():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 2
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 0
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func drop_heart():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 1
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func _on_bat_spawn_rate_timeout():
	worldBatCount = 0
	count_bats()
	if worldBatCount < maxBatsInWorld and position.distance_to(player.position) <= enemy.ENEMY_DETECTION_RANGE:
		
		var batInstance = bat.instantiate()
		batInstance.position = Vector2(position.x - 20, position.y)
		main.add_child(batInstance, true)
		
		batInstance = bat.instantiate()
		batInstance.position = Vector2(position.x + 20 , position.y)
		main.add_child(batInstance, true)
		print("added ab at")
	
		if startFleeTimer:
			justSummoned = true
			startFleeTimer = false
			$Timer.start(4)

func count_bats():
	for child in main.get_children():
		if child.name.contains("Bat"):
			worldBatCount+= 1

func _play_hurt():
	pass
func take_damage():
	rng.randomize()
	$HealthComponent.deductHealth()
	if rng.randi_range(1,2) == 2:
		$AnimationPlayer.play("summonerHurt1")
	else:
		$AnimationPlayer.play("summonerHurt2")
	print($HealthComponent.health, " <--  sumowner helth | is dead? --> ", $HealthComponent.isDead)
	if $HealthComponent.isDead:
		death()
		spawner.enemyKillCount += 1
		


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "summonerDeath":
		queue_free()
	


func _on_boss_kill_timeout():
	$AnimationPlayer.play("summonerDeath")


func _on_timer_timeout():
	justSummoned = false
	startFleeTimer = true
