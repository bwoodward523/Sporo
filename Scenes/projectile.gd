extends CharacterBody2D

var speed: float 
var dir: Vector2
var spawnPos: Vector2
var spawnRot: float
var zdex: int
var damage: int
var sprite: Texture
var maxDistance: float 
var scale1: Vector2
var startRotation: float
var rotationRate: float
@export var waterBullet: Texture2D
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	scale = scale1
	$Sprite2D.set_texture(sprite)
	var rng = RandomNumberGenerator.new()
	if rng.randi_range(1,15) == 1:
		if sprite == waterBullet:
			$PointLight2D.set_texture(sprite)
	else:
		$PointLight2D.set_texture(null)
	look_at(get_global_mouse_position())
	rotation_degrees += startRotation
func _physics_process(delta):
	velocity = dir * delta * speed
	$Sprite2D.rotation = $Sprite2D.rotation + rotationRate * delta

	_distance_to_destroy_projectile()
	move_and_collide(velocity)

	

func _distance_to_destroy_projectile():
	var distanceTraveled = spawnPos.distance_to(global_position)
	if distanceTraveled > maxDistance:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name.contains("Enemy"):  #this is the start of the name of the parent enemy node
		#print("hit enemy")
		var hp = body.get_node("HealthComponent")
		for i in damage:
			if body.has_method("take_damage"):
				body.take_damage()
			else:
				hp.deductHealth()	
		body.isHurt = true
		body._play_hurt()
		#print("enemy hp: ", hp.health)
	queue_free()
