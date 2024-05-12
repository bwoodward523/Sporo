extends CharacterBody2D
@export var SPEED = 200
@export var DETECTION_RANGE = 100
@export var CHARGE_SPEED = 1000

@onready var player = get_parent().get_node("player")

var behaviorState = "Searching"
var stopMovement = false
var dir: Vector2
#@onready var health = $HealthComponent.health
func _physics_process(delta):
	if behaviorState == "Searching":
		dir = (player.position - position).normalized()
		velocity = dir * SPEED 
		if !stopMovement:
			move_and_collide(velocity * delta)
		checkForAttack()
	
	if behaviorState == "Charging":
		move_and_collide(velocity * delta) #velocity is defined when the animation is finished
	if $HealthComponent.isDead:
		queue_free()
	
	
func checkForAttack():
	if position.distance_to(player.position) <= DETECTION_RANGE:
		$AnimationPlayer.play("changeColorThenCharge")
		stopMovement = true
		set_collision_mask_value(3, false) #Disable collision with other enemies because homie is homing


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "changeColorThenCharge":
		dir = (player.position - position).normalized()
		velocity = dir * CHARGE_SPEED
		behaviorState = "Charging"
		look_at(player.position)
		rotation_degrees += 90
