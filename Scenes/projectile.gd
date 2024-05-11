extends CharacterBody2D

@export var SPEED = 200

var dir: Vector2
var spawnPos: Vector2
var spawnRot: float
var zdex: int

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	
func _physics_process(delta):
	position += dir * delta * SPEED
	$Sprite2D.rotation = $Sprite2D.rotation + 5 * delta
	move_and_slide()


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.name.contains("Enemy"):  #this is the start of the name of the parent enemy node
		#print("hit enemy")
		var hp = body.get_node("HealthComponent")
		hp.deductHealth()
		#print("enemy hp: ")
		#print(hp.health)
	queue_free()
