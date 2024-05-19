extends CharacterBody2D

var item_scene := preload("res://Scenes/coin.tscn")
var gnomeBullet := preload("res://Enemies/Scenes/gnome_bullet.tscn")
var bat = preload("res://Enemies/Scenes/BatBullet.tscn")
var skyLaser = preload("res://Enemies/Scenes/SkyLaser.tscn")

@onready var player = get_parent().get_node("player")
@export var bossHealth: int
@export var bulletSprites: Array[Texture2D]
@export var tentacleRotationAmount:float
@export var tentacleShotCount:int
@export var tentacleSpinSpeed: float
@export var tentacleBulletSpeed: float

@export var snipeSpeed: float

@export var batsPerCloak: int
@export var bulletPukeSpeed:float

var snipeCounter = 0
@export var snipesBeforeReset: float
@export var snipeResetTimeSec:float
var isHurt = true
var rng = RandomNumberGenerator.new()

var phase = "none"

var aimRotation: float
var aimDir:= Vector2.RIGHT

var laserWallY
var laserWallDegrees = 0
func _ready():
	$HealthBar.max_value = bossHealth
	$HealthBar.value = bossHealth
	$HealthComponent.health = bossHealth
	$TentacleTimer.set_paused(true)
	$ShootAtPlayer.set_paused(true)
	$ShootCloak.set_paused(true)
	$PhaseSwitcher.wait_time = 5
	$ShootLaser.set_paused(false)
	phase_manager()

func _physics_process(delta):
	pass

func phase_manager():
	if phase == "tentacle1":
		$ShootCloak.set_paused(true)
		$ShootAtPlayer.set_paused(false)
		$TentacleTimer.set_paused(false)
		tentacleRotationAmount = 90
		tentacleShotCount = 4
		tentacleSpinSpeed = 30
		tentacleBulletSpeed = 400
		$ShootAtPlayer.wait_time = .1
	if phase == "tentacle2":
		$ShootCloak.set_paused(true)
		$ShootAtPlayer.set_paused(false)
		tentacleRotationAmount = sqrt(7)*100
		tentacleShotCount = 5
		tentacleSpinSpeed = sqrt(7)
		tentacleBulletSpeed = 350
	if phase == "cloakBats":
		$ShootCloak.set_paused(false)
		#$TentacleTimer.set_paused(true)
		#$ShootAtPlayer.set_paused(true)
	laserWallY = position.y
func switch_phase():
	if phase == "none":
		phase = "tentacle1"
		$PhaseSwitcher.wait_time = 5
	elif phase == "tentacle1":
		phase = "tentacle2"
		$PhaseSwitcher.wait_time = 1
	elif phase == "tentacle2":
		phase = "cloakBats"
		rng.randomize()
		$PhaseSwitcher.wait_time = 5
	elif phase == "cloakBats":
		phase = "tentacle1"
		$PhaseSwitcher.wait_time = 5
func _on_phase_switcher_timeout():
	switch_phase()
	phase_manager()
	

func shootAtPlayer():
	var playerDir = (player.position - position).normalized()
	var bulletInstance = gnomeBullet.instantiate()
	bulletInstance.position = position
	bulletInstance.bulletSpeed = snipeSpeed
	bulletInstance.dir = playerDir
	bulletInstance.sprite1 = bulletSprites[1]
	get_parent().add_child(bulletInstance, true)


func _on_shoot_at_player_timeout():
	shootAtPlayer()
	snipeCounter += 1
	if snipeCounter >= snipesBeforeReset:
		$ShootAtPlayer.set_paused(true)
		$SnipeReset.start(snipeResetTimeSec)

func shootSkyLaser(pos: Vector2):
	var playerDir = (player.position - position).normalized()
	var bulletInstance = skyLaser.instantiate()	
	bulletInstance.position = pos
	bulletInstance.speed = 500
	get_parent().add_child(bulletInstance, true)
	
func shootSkyLaserWall():
	var laserCount = 20
	var laserPos = Vector2(position.x - laserCount*100/2, laserWallY)
	for i in laserCount: 
		if i != laserCount/2 and  i != laserCount/2 +1 and i != laserCount/2 -1:
			shootSkyLaser(Vector2(laserPos.x + i * 100, laserPos.y).rotated(rad_to_deg(laserWallDegrees)))
func _on_snipe_reset_timeout():
	print("My timer ran teehee")
	$ShootAtPlayer.set_paused(false)
	snipeCounter = 0

func rotateShoot(deg: float):
	deg = deg_to_rad(deg)
	var startingDir = aimDir
	aimDir = aimDir.rotated(deg)
	var bulletInstance = gnomeBullet.instantiate()
	bulletInstance.position = position
	bulletInstance.bulletSpeed = tentacleBulletSpeed
	bulletInstance.dir = aimDir
	bulletInstance.sprite1 = bulletSprites[0]
	bulletInstance.lifeTime = 20.0
	get_parent().add_child(bulletInstance, true)
	
func _on_tentacle_timer_timeout():
	for i in tentacleShotCount:
		rotateShoot(tentacleRotationAmount * i)
	aimDir = aimDir.rotated(deg_to_rad(tentacleSpinSpeed))


func shootCloak(proj: PackedScene, bulletSpeed: float):
	var playerDir = (player.position - position).normalized()
	var bulletInstance = proj.instantiate()
	if proj == gnomeBullet:
		var rand = RandomNumberGenerator.new()
		rand.randomize()
		bulletInstance.position = position
		bulletInstance.bulletSpeed = bulletSpeed
		bulletInstance.dir = playerDir.rotated(rand.randf_range(-30,30))
		bulletInstance.sprite1 = bulletSprites[1]
	else:
		bulletInstance.position = position
		bulletInstance.dir = playerDir
	get_parent().add_child(bulletInstance, true)
	

func _on_shoot_cloak_timeout():
	if rng.randi_range(1,2) == 1:
		shootCloak(bat, 0)
	else:
		shootCloak(gnomeBullet, bulletPukeSpeed)


func _play_hurt():
	pass

func take_damage():
	$HealthComponent.deductHealth()
	check_death()
	set_health_bar()

func check_death():
	if $HealthComponent.isDead:
		$AnimationPlayer.play("bossDeath")
		$CollisionShape2D.disabled = true
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "bossDeath":
		queue_free()

func set_health_bar():
	$HealthBar.value = $HealthComponent.health




func _on_shoot_laser_timeout():
	shootSkyLaser(Vector2(position.x + randi_range(-400,400), randi_range(-400,400)+position.y))


func _on_shoot_laser_wall_timeout():
	shootSkyLaserWall()
	laserWallY += 100
	laserWallDegrees += 5
