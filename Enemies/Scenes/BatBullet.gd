extends CharacterBody2D

var item_scene := preload("res://Scenes/coin.tscn")

var addDeathTimer= true
@export var batSpeed = 20
@export var knockbackForce: float
@onready var player = get_parent().get_node("player")
@onready var spawner = get_parent().get_node("EnemySpawner")
@onready var main = get_parent()
var dir
var knockBack= Vector2.ZERO
var isDead = false
var dieOnce = true
func _ready():
	# Make the bats pausable
	process_mode = Node.PROCESS_MODE_PAUSABLE
	pass
func _physics_process(delta):
	
	if spawner.bandaidNoMoreBoss && addDeathTimer && spawner.canSpawnEnemies:
		addDeathTimer = false
		$BossKill.start(1)
	# Set velocity and direction to target player
	dir = (player.position - position).normalized()
	velocity += dir * batSpeed * delta + knockBack
	# Add the kb for bats to swing
	if velocity.length() > 600:
		velocity -= dir*  batSpeed * delta + knockBack
	knockBack = lerp(knockBack, Vector2.ZERO, .1)
	move_and_slide()
	if $AnimatedSprite2D.modulate.a == 0:
		print("no more alpha")
		queue_free()
	
func _on_bat_take_damage_area_area_entered(area):
	# Kill bats when they take damage
	if !area.name == "BatTakeDamageArea" :
		#area.get_parent().queue_free()
		print(area.name)
		if area.is_in_group("playerBullet"):
			area.get_parent().batKillCount += 1
			
		death()

func death():
	# Death routine
	if dieOnce:
		dieOnce = false
		$AudioStreamPlayer2D.play()
		if randi_range(0, 50) == 21: #hehehe
				drop_ammo()
		$BatTakeDamageArea.set_collision_mask_value(2,false)
		$BatDamageArea.set_collision_mask_value(1, false)
		$AnimationPlayer.clear_queue()
		$AnimationPlayer.play("batDeath")
		Data.bats += 1
		isDead = true
		spawner.enemyKillCount += .5
		dir = Vector2(0,0)
func drop_ammo():
	# Bats only drop ammo when killed
	var item = item_scene.instantiate()
	item.position = position
	item.item_type = 4
	main.call_deferred("add_child", item)
	item.add_to_group("items")
func _on_bat_damage_area_body_entered(body):
	# Knock back bats when they collide with the player
	if body.name.contains("player"):	
		body.take_damage()
		knockBack = -dir * knockbackForce



func _on_animation_player_animation_finished(anim_name):
	# Free animation queue when bats die
	if anim_name == "batDeath":
		queue_free()


func _on_timer_timeout():
	# Death timer is done, play death animation
	$AnimationPlayer.play("batDeath")


func _on_boss_kill_timeout():
	# If lich is killed, kill all bats
	$AnimationPlayer.play("batDeath")
