extends CharacterBody2D

var item_scene := preload("res://Scenes/coin.tscn")
var gnomeBullet := preload("res://Enemies/Scenes/gnome_bullet.tscn")
@onready var player = get_parent().get_node("player")
@export var bossHealth: int
@export var bulletSprites: Array[Texture2D]
@export var tentacleRotationAmount:float
@export var tentacleShotCount:int
@export var tentacleSpinSpeed: float
@export var tentacleBulletSpeed: float
var isHurt = true

var phase = "tentacle1"

var aimRotation: float
var aimDir:= Vector2.RIGHT
func _ready():
	$HealthComponent.health = bossHealth
	$TentacleTimer.set_paused(true)
	phase_manager()
func _physics_process(delta):
	pass

func phase_manager():
	if phase == "tentacle1":
		$TentacleTimer.set_paused(false)
		tentacleRotationAmount = 90
		tentacleShotCount = 4
		tentacleSpinSpeed = 10
		tentacleBulletSpeed = 100
	if phase == "tentacle2":
		#$ShootAtPlayer.set_paused(false)
		tentacleRotationAmount = sqrt(7)*100
		tentacleShotCount = 5
		tentacleSpinSpeed = sqrt(7)
		tentacleBulletSpeed = 200
func switch_phase():
	if phase == "none":
		phase = "tentacle1"
	if phase == "tentacle1":
		phase = "tentacle2"
func _on_phase_switcher_timeout():
	switch_phase()
	phase_manager()
	

func shootAtPlayer(xTimesFasterThanTentacle):
	var playerDir = player.position - position
	var bulletInstance = gnomeBullet.instantiate()
	bulletInstance.position = position
	bulletInstance.bulletSpeed = tentacleBulletSpeed * xTimesFasterThanTentacle
	bulletInstance.dir = playerDir
	bulletInstance.sprite1 = bulletSprites[1]
	get_parent().add_child(bulletInstance, true)
	print("Hello?")

func _on_shoot_at_player_timeout():
	shootAtPlayer(3)
	

func rotateShoot(deg: float):
	deg = deg_to_rad(deg)
	aimDir = aimDir.rotated(deg)
	var bulletInstance = gnomeBullet.instantiate()
	bulletInstance.position = position
	bulletInstance.bulletSpeed = tentacleBulletSpeed
	bulletInstance.dir = aimDir
	bulletInstance.sprite1 = bulletSprites[0]
	get_parent().add_child(bulletInstance, true)
	


func _on_tentacle_timer_timeout():
	for i in tentacleShotCount:
		rotateShoot(tentacleRotationAmount * i)
	aimDir = aimDir.rotated(deg_to_rad(tentacleSpinSpeed))
	
func _play_hurt():
	pass

func take_damage():
	$HealthComponent.deductHealth()
	check_death()

func check_death():
	if $HealthComponent.isDead:
		$AnimationPlayer.play("bossDeath")
		$CollisionShape2D.disabled = true
		
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "bossDeath":
		queue_free()



