extends CharacterBody2D
#@export var SPEED = 200
var SPEED
@export var DETECTION_RANGE = 100
@export var CHARGE_SPEED = 1000
@export var enemy: Resource
@onready var player = get_parent().get_node("player")

var behaviorState = "Searching"
var stopMovement = false
var dir: Vector2

var attackAnimation: String
var hurtAnimation: String
var deathAnimation: String

var isHurt = false 

var particleVel: Vector2
func _ready():
	#Assign resource values
	$HealthComponent.health = enemy.ENEMY_HEALTH
	SPEED = enemy.ENEMY_SPEED
	DETECTION_RANGE = enemy.ENEMY_DETECTION_RANGE
	#attackAnimation = enemy.ENEMY_ATTACK_ANIMATION
	#hurtAnimation = enemy.ENEMY_HURT_ANIMATION
	deathAnimation = enemy.ENEMY_DEATH_ANIMATION

func _physics_process(delta):
	#print($HealthComponent.health, "I am: ", name)
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
			print("im ded")
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			if rng.randi_range(1,2) == 2:
				scale.x = -scale.x
			$AnimationPlayer.clear_queue()
			$AnimationPlayer.play(deathAnimation)

			$CollisionShape2D.disabled = true
			
		
func checkForAttack():
	if position.distance_to(player.position) <= DETECTION_RANGE:
		#$AnimationPlayer.play(attackAnimation)
		stopMovement = true
		set_collision_mask_value(3, false) #Disable collision with other enemies because homie is homing

func _play_hurt():
	if isHurt:
		isHurt = false
		#$AnimationPlayer.play(hurtAnimation)

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
		

func _on_lifespan_timeout():
	queue_free()
