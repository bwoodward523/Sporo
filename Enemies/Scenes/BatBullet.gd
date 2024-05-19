extends CharacterBody2D

var addDeathTimer= true
@export var batSpeed = 20
@export var knockbackForce: float
@onready var player = get_parent().get_node("player")
@onready var spawner = get_parent().get_node("EnemySpawner")
var dir
var knockBack= Vector2.ZERO
var isDead = false
var dieOnce = true
func _ready():
	pass
func _physics_process(delta):
	if spawner.bandaidNoMoreBoss && addDeathTimer and spawner.canSpawnEnemies:
		addDeathTimer = false
		$BossKill.start(1)
	dir = (player.position - position).normalized()
	velocity += dir * batSpeed * delta + knockBack
	if velocity.length() > 600:
		velocity -= dir*  batSpeed * delta + knockBack
	knockBack = lerp(knockBack, Vector2.ZERO, .1)
	move_and_slide()
	
func _on_bat_take_damage_area_area_entered(area):
	
	if !area.name == "BatTakeDamageArea" :
		area.get_parent().queue_free()
		death()

func death():
	if dieOnce:
		dieOnce = false
		$AudioStreamPlayer2D.play()
		$BatTakeDamageArea.set_collision_mask_value(2,false)
		$BatDamageArea.set_collision_mask_value(1, false)
		$AnimationPlayer.clear_queue()
		$AnimationPlayer.play("batDeath")
		isDead = true
		spawner.enemyKillCount += .5
		dir = Vector2(0,0)

func _on_bat_damage_area_body_entered(body):
	if body.name.contains("player"):	
		body.take_damage()
		knockBack = -dir * knockbackForce



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "batDeath":
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_boss_kill_timeout():
	$AnimationPlayer.play("batDeath")
