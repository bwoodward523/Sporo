extends "res://Enemies/Classes/enemy_class.gd"

class_name RANGED_ENEMY

@export var PROJECTILE_TYPE: Array[PackedScene]

# Initialize the resource values from ENEMY and RangedEnemy
func _initialize():
	# Initialize ENEMY properties if necessary
	#run this function in the _ready()
	pass

#func shoot(bulletPos: Vector2, projectileTypeIndex: int, currentRotationDegrees: float, nextBulletRot: float):
	#if projectileTypeIndex<0 or projectileTypeIndex >= projectileType.size():
		#print("Invalid projectile type index")
		#return
	#var projectile_scene = projectileType[projectileTypeIndex].instantiate()
	#if projectile_scene:
		#pass
			#Spawn bullet desired in desired world position
			#projectile_scene.rotation_degrees = currentRotationDegrees + nextBulletRot
			#projectile_scene.position = set_bullet_position()
			
func set_bullet_position():
	pass
func set_bullet_rotation():
	pass
