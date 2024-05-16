extends Area2D

@export var bulletSpeed = 200
var dir: Vector2

func _ready():
	pass
func _physics_process(delta):
	position+= dir * bulletSpeed * delta
	
func _on_body_entered(body):
	if body.name.contains("player"):
		body.take_damage()
		print(body.name, " has been bulletted")
	queue_free()
	



func _on_lifetime_timeout():
	queue_free()
