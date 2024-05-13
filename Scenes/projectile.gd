extends CharacterBody2D

var speed: float 
var dir: Vector2
var spawnPos: Vector2
var spawnRot: float
var zdex: int
var damage: int
var sprite: Texture
var maxDistance: float 

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	$Sprite2D.set_texture(sprite)
	
func _physics_process(delta):
	velocity = dir * delta * speed
	$Sprite2D.rotation = $Sprite2D.rotation + 5 * delta
	#move_and_slide()
	if abs(rotation_degrees) >= 90: #This kinda works. goal is for gun to face a dir that feels right
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false
		
	if abs(rotation_degrees) >= 180:
		rotation_degrees *= -1
	_distance_to_destroy_projectile()
	move_and_collide(velocity)
#func _on_timer_timeout():
	#queue_free()

func _distance_to_destroy_projectile():
	var distanceTraveled = spawnPos.distance_to(global_position)
	if distanceTraveled > maxDistance:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name.contains("Enemy"):  #this is the start of the name of the parent enemy node
		#print("hit enemy")
		var hp = body.get_node("HealthComponent")
		for i in damage:
			hp.deductHealth()
		
		#print("enemy hp: ")
		#print(hp.health)
	queue_free()
