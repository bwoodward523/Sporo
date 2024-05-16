extends CharacterBody2D

@export var enemy: Resource
@onready var player = get_parent().get_node("player")
@onready var bullet1 = enemy.PROJECTILE_TYPE[0]
@onready var enemyScene = load("res://Enemies/Scenes/enemy_gnome.tscn")

var behaviorState = "Searching"
var isHurt: bool
@onready var detectionRange = enemy.ENEMY_DETECTION_RANGE
@export var fleeRange: float
var fromParentGnome = false
var canMultiply = false
var shotCount = 0
@export var shotsUntilMultiply: int

func _physics_process(delta):
	manage_states()
	#print(behaviorState)
	if behaviorState == "Searching":
		velocity = (player.position - position).normalized() * enemy.ENEMY_SPEED
		move_and_collide(velocity * delta)
		$FireRate.stop()
	if behaviorState == "Attacking":
		#enable timer cooldown
		if $FireRate.time_left == 0:
			$FireRate.start()
	
	if behaviorState == "Fleeing":
		#opposite direction from searching
		velocity = -(player.position - position).normalized() * enemy.ENEMY_SPEED
		move_and_collide(velocity * delta)

	if canMultiply:
		multiply_self()
		

	if $HealthComponent.isDead:
		death()
func death():
	print("popped gnome")
	queue_free()
	
func take_damage():
	$HealthComponent.deductHealth()
func shoot():
	var bulletInstance = bullet1.instantiate()
	bulletInstance.position = position
	bulletInstance.dir = (player.position - position).normalized()
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
	if behaviorState == "Attacking" or behaviorState == "Fleeing":
		canMultiply = true
