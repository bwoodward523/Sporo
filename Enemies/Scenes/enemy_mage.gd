extends CharacterBody2D

@export var enemy: Resource
@onready var main = get_node("/root/main")
@onready var player = get_parent().get_node("player")

var item_scene := preload("res://Scenes/coin.tscn")
@onready var bullet1 = enemy.PROJECTILE_TYPE[0]
@onready var enemyScene = preload("res://Enemies/Scenes/enemy_gnome.tscn")
@onready var enemySpawner = get_parent().get_node("EnemySpawner")
var behaviorState = "Searching"
var previousState
var isHurt: bool
@onready var detectionRange = enemy.ENEMY_DETECTION_RANGE
@export var fleeRange: float
var fromParentGnome = false
var canMultiply = false
var shotCount = 0
var doOnce = true
@export var projectileSpeed: float
@export var shotsPerShot: int
@export var shotSpread: float
var savedTime= 0.0
var rng = RandomNumberGenerator.new()

func _ready():
	$HealthComponent.health = enemy.ENEMY_HEALTH
	rng.randomize()

func _physics_process(delta):
	manage_states()

	if behaviorState == "Searching":
		velocity = (player.position - position).normalized() * enemy.ENEMY_SPEED
		move_and_collide(velocity * delta)
		$FireRate.stop()
		$AnimatedSprite2D.play("walk")
	if behaviorState == "Attacking":
		#enable timer cooldown
		$AnimatedSprite2D.play("idle")
		velocity = Vector2.ZERO* enemy.ENEMY_SPEED 
		move_and_collide(velocity * delta)
		if $FireRate.time_left == 0:
			$FireRate.start()
	
	if $HealthComponent.isDead:
		death()

func drop_item():
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 0
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func death():
	if doOnce:
		#print("popped gnome")
		if randi_range(0,3) == 2:
			drop_item()
		if rng.randi_range(1,2) == 2:
			scale.x = -scale.x
		$AnimationPlayer.play("mageDeath")
		$AnimationPlayer.clear_queue()
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		doOnce = false
	
	
func take_damage():
	$HealthComponent.deductHealth()
	rng.randomize()
	if rng.randi_range(1,2) == 2:
		$AnimationPlayer.play("mageHurt1")	
	else:
		$AnimationPlayer.play("mageHurt2")


func _play_hurt():
	pass

func manage_states():
	previousState = behaviorState
	if position.distance_to(player.position) <= detectionRange:
		behaviorState = "Attacking"
		if previousState == "Searching":
			$FireRate.start(savedTime)
	else:
		behaviorState = "Searching"
		savedTime = $FireRate.time_left
		$FireRate.stop()
	
func attack():
	velocity = Vector2(0,0)
func _on_fire_rate_timeout():
	shoot()
	shotCount+= 1
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "mageDeath":
		queue_free()


func shoot():
	for i in shotsPerShot:
		var bulletInstance = bullet1.instantiate()
		bulletInstance.position = position
		bulletInstance.bulletSpeed = projectileSpeed*.6
		bulletInstance.sprite1 = enemy.ENEMY_TEXTURE
		var predictionDirection = interceptionDirection(player.position, position, player.velocity, projectileSpeed)
		#predictionDirection += player.velocity.normalized()
		if(predictionDirection == Vector2.ZERO):
			bulletInstance.dir = _assign_bullet_direction(i, (player.position - position).normalized(), shotsPerShot, shotSpread)
		else:
			bulletInstance.dir = _assign_bullet_direction(i, predictionDirection, shotsPerShot, shotSpread) 
		#bulletInstance.rotation = position.angle_to_point(player.global_position)
		get_parent().add_child(bulletInstance)
	
func _assign_bullet_direction(bulletNumber: int, dir: Vector2, shots: int, spread:float):
	var bulletDirection = (get_global_mouse_position() - player.position).normalized()
	var returnDir: Vector2
	returnDir = dir.rotated(deg_to_rad(bulletNumber*spread - (shots/2 * spread)))
	return returnDir

func interceptionDirection(a: Vector2, b: Vector2, vA: Vector2, sB: float):
	var newShootDir: Vector2
	var aToB = b - a
	var dC = aToB.length()
	var alpha = aToB.angle_to(vA)
	var sA = vA.length()
	var r = sA / sB
	
	var quadResultArr: Array
	quadResultArr = solveQuadratic((1-(r*r)), (2*r*dC*cos(alpha)), -(dC*dC))
	if quadResultArr[0] == INF:
		#There is no solution, no way to predict the direction (bullets not fast enough and cant reach target)
		print("i cant aim")
		return Vector2.ZERO
	var dA = max(quadResultArr[0], quadResultArr[1])
	var t = dA / sB
	var c = a + vA * t
	newShootDir = (c - b).normalized()
	#print(newShootDir.x, " ", newShootDir.y)
	return newShootDir
	
func solveQuadratic(a: float, b: float, c: float ):
	var roots = [0.0,0.0]
	var discriminant = b * b - 4*a*c
	if discriminant < 0:
		#set the roots to arbitrary values since they dont matter
		roots[0] = INF
		roots[1] = -INF
		return roots
	else:
		roots[0] = ((-b + sqrt(discriminant)) / 2*a)
		roots[1] = ((-b - sqrt(discriminant)) / 2*a)
		return roots
