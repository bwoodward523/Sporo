extends CharacterBody2D
@onready var playerProjectile = load("res://Scenes/projectile.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_parent()
@onready var barrel = get_node("Rifle/Barrel")
@onready var rifle = get_node("Rifle")

var selectedItem
var canShoot = true
var ammoCount: int
func _ready():
	selectedItem = player.item2
	ammoCount = selectedItem.MAX_AMMO
	print(typeof(rifle.texture), " boggas1")
	print(typeof(player.item1.ITEM_TEXTURE), " boggas2")
	rifle.texture = selectedItem.ITEM_TEXTURE
	#if (player.item1.ITEM_NAME == "Fist"):
		#rifle.visible = false
	
func _physics_process(delta):
	if Input.is_action_pressed("shoot"):
		if canShoot:
			if ammoCount > 0:
				playerShoot()
	#rotate gun towards mouse
	look_at(get_global_mouse_position())
	#print(rotation_degrees)
	
	if abs(rotation_degrees) >= 90: #This kinda works. goal is for gun to face a dir that feels right
		$Rifle.flip_v = true
	else:
		$Rifle.flip_v = false
		
	if abs(rotation_degrees) >= 180:
		rotation_degrees *= -1


func playerShoot():
	var instance = playerProjectile.instantiate()
	var bulletDirection = (get_global_mouse_position() - player.position).normalized()
	instance.speed = selectedItem.PROJECTILE_SPEED
	instance.damage = selectedItem.DAMAGE
	instance.dir = bulletDirection
	instance.spawnPos = Vector2(barrel.global_position.x, barrel.global_position.y)
	instance.spawnRot = rotation
	instance.zdex = z_index -1
	main.add_child(instance)
	ammoCount -= 1
	#Wait for firerate cooldown
	canShoot = false
	$FireRate.start(selectedItem.FIRE_RATE)

func _on_fire_rate_timeout():
	#enable shooting
	canShoot = true
