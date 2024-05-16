extends CharacterBody2D
@onready var playerProjectile = preload("res://Scenes/projectile.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_parent()
@onready var barrel = get_node("Rifle/Barrel")
@onready var rifle = get_node("Rifle")

var hasSpread = false
var selectedItem
var canShoot = true
var ammoCount: int
var bulletsPerShot: int

func switch_weapon():
	selectedItem = player.Active_Item
	ammoCount = selectedItem.MAX_AMMO
	rifle.texture = selectedItem.ITEM_TEXTURE
	if (selectedItem.ITEM_NAME == "Fist"):
		rifle.visible = false
	else:
		rifle.visible = true
	print(ammoCount)
	if ammoCount > 0:
		canShoot = true
func _ready():
	selectedItem = player.Active_Item
	ammoCount = selectedItem.MAX_AMMO

	rifle.texture = selectedItem.ITEM_TEXTURE
	if (selectedItem.ITEM_NAME == "Fist"):
		rifle.visible = false
	else:
		rifle.visible = true
		rifle.texture = selectedItem.ITEM_TEXTURE


func _physics_process(delta):
	
	selectedItem = player.Active_Item
	#ammoCount = selectedItem.MAX_AMMO
	#if (selectedItem.ITEM_NAME == "Fist"):
	#	rifle.visible = false
	#else:
	#	rifle.texture = selectedItem.ITEM_TEXTURE
	#	rifle.visible = true
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
	for i in selectedItem.SHOTS_PER_SHOT:
		
		var instance = playerProjectile.instantiate()
		instance.scale1 = selectedItem.PROJECTILE_SIZE
		instance.dir = _assign_bullet_direction(i)
		instance.speed = selectedItem.PROJECTILE_SPEED
		instance.sprite = selectedItem.PROJECTILE_TEXTURE
		instance.damage = selectedItem.DAMAGE
		instance.startRotation = selectedItem.PROJECTILE_ROTATION
		instance.rotationRate = selectedItem.PROJECTILE_ROTATION_RATE
		instance.maxDistance = selectedItem.MAX_BULLET_DISTANCE
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
	if ammoCount > 0:
		canShoot = true

func _assign_bullet_direction(bulletNumber: int):
	if selectedItem.SPREAD_WIDTH != 0:
			hasSpread = true
	
	var bulletDirection = (get_global_mouse_position() - player.position).normalized()
	var returnDir: Vector2
	if hasSpread:
		returnDir = bulletDirection.rotated(deg_to_rad(bulletNumber*selectedItem.SPREAD_WIDTH - (selectedItem.SHOTS_PER_SHOT/2 * selectedItem.SPREAD_WIDTH)))
	else:
		returnDir = bulletDirection
	return returnDir
