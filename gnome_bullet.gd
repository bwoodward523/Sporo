extends Area2D

@export var bulletSpeed = 200
var dir: Vector2
var sprite1:Texture2D
func _ready():
	$Sprite2D.texture = sprite1
func _physics_process(delta):
	position+= dir * bulletSpeed * delta
	
func _on_body_entered(body):
	if body.name.contains("player"):
	#	body.take_damage()
	#	print(body.name, " has been bulletted")
	#queue_free()
		pass
	



func _on_lifetime_timeout():
	queue_free()


func _on_area_entered(area):
	pass # Replace with function body.
