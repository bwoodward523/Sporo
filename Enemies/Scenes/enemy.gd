extends CharacterBody2D
#@export var SPEED = 200
var SPEED
var DETECTION_RANGE
@export var CHARGE_SPEED = 1000
@export var enemy: Resource
@onready var main = get_node("/root/main")
@onready var player = get_parent().get_node("player")
@onready var spawner = get_parent().get_node("EnemySpawner")
var item_scene := preload("res://Scenes/coin.tscn")
var addDeathTimer = true
var behaviorState = "Searching"
var stopMovement = false
var dir: Vector2
var isDead = false
var attackAnimation: String
var hurtAnimation: String
var deathAnimation: String

var isHurt = false 

var particleVel: Vector2
func _ready():
	#Assign resource values
	process_mode = Node.PROCESS_MODE_PAUSABLE
	$Sprite2D.set_texture(enemy.ENEMY_TEXTURE)
	$HealthComponent.health = enemy.ENEMY_HEALTH
	SPEED = enemy.ENEMY_SPEED
	DETECTION_RANGE = enemy.ENEMY_DETECTION_RANGE
	attackAnimation = enemy.ENEMY_ATTACK_ANIMATIONS[0]
	hurtAnimation = enemy.ENEMY_HURT_ANIMATION
	deathAnimation = enemy.ENEMY_DEATH_ANIMATION

func _physics_process(delta):
	if spawner.bandaidNoMoreBoss && addDeathTimer:
		addDeathTimer = false
		$BossKill.start(1)
	if $AnimationPlayer.current_animation != deathAnimation:
		if behaviorState == "Searching":
			dir = (player.position - position).normalized()
			velocity = dir * SPEED 
			if !stopMovement:
				move_and_collide(velocity * delta)
			checkForAttack()
		
		if behaviorState == "Charging":
			move_and_collide(velocity * delta) #velocity is defined when the animation is finished
		if $HealthComponent.isDead:
			isDead = true
			spawner.enemyKillCount += 1
			$AudioStreamPlayer2D.play()
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			if rng.randi_range(1,2) == 2:
				scale.x = -scale.x
			$AnimationPlayer.play(deathAnimation)
			$AnimationPlayer.clear_queue()
			$CollisionShape2D.disabled = true
			rotation_degrees = 0
			if randi_range(0,3) == 2:
				drop_item()
			if randi_range(0, 100) == 69: #hehehe
				drop_heart()
			if randi_range(0, 50) == 21: #hehehe
				drop_ammo()
func drop_ammo():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 2
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func drop_heart():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 1
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 0
	main.call_deferred("add_child", item)
	item.add_to_group("items")

func checkForAttack():
	if position.distance_to(player.position) <= DETECTION_RANGE:
		$AnimationPlayer.play(attackAnimation)
		stopMovement = true
		set_collision_mask_value(3, false) #Disable collision with other enemies because homie is homing

func _play_hurt():
	if isHurt:
		$AnimationPlayer.play(hurtAnimation)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == attackAnimation:
		dir = (player.position - position).normalized()
		velocity = dir * CHARGE_SPEED
		behaviorState = "Charging"
		look_at(player.position)
		rotation_degrees += 90
	if anim_name == hurtAnimation:
		isHurt = false
	if anim_name == deathAnimation:
		particleVel = velocity
		velocity = Vector2(0,0)
		queue_free()
		
func take_damage():
	$HealthComponent.deductHealth()
	
func _on_lifespan_timeout():
	$AnimationPlayer.play("gruntDeath")
	Data.grunts += 1


func _on_boss_kill_timeout():
	$AnimationPlayer.play("gruntDeath")
