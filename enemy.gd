extends CharacterBody2D
@export var SPEED = 2
@onready var player = get_parent().get_node("player")

var dir: Vector2
#@onready var health = $HealthComponent.health
func _physics_process(delta):
	dir = player.position - position
	velocity = dir * SPEED * delta
	move_and_collide(velocity)
