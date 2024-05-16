extends Node2D


@export var batSpeed = 400
@export var knockbackForce: float
@onready var player = get_parent().get_node("player")
var dir
var knockBack= Vector2.ZERO

func _ready():
	pass
func _physics_process(delta):
	dir = (player.position - position).normalized()
	position += dir * batSpeed * delta + knockBack
	knockBack = lerp(knockBack, Vector2.ZERO, .1)

func _on_bat_take_damage_area_area_entered(area):
	queue_free()


func _on_bat_damage_area_body_entered(body):
	if body.name.contains("player"):	
		body.take_damage()
		knockBack = -dir * knockbackForce

