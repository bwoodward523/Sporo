extends CharacterBody2D

@export var SPEED = 100

var dir: Vector2
var spawnPos: Vector2
var spawnRot: float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta):
	position += dir * delta * SPEED
	move_and_slide()


func _on_timer_timeout():
	queue_free()
