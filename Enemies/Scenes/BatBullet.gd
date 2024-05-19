extends CharacterBody2D


@export var batSpeed = 20
@export var knockbackForce: float
@onready var player = get_parent().get_node("player")
var dir
var knockBack= Vector2.ZERO

func _ready():
	pass
func _physics_process(delta):
	dir = (player.position - position).normalized()
	velocity += dir * batSpeed * delta + knockBack
	if velocity.length() > 600:
		velocity -= dir*  batSpeed * delta + knockBack
	knockBack = lerp(knockBack, Vector2.ZERO, .1)
	move_and_slide()
	
func _on_bat_take_damage_area_area_entered(area):
	
	if !area.name == "BatTakeDamageArea":
		area.get_parent().queue_free()
		death()

func death():
	$AudioStreamPlayer2D.play()
	$BatTakeDamageArea.set_collision_mask_value(2,false)
	$BatDamageArea.set_collision_mask_value(1, false)
	$AnimationPlayer.play("batDeath")
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
