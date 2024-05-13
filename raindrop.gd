extends CharacterBody2D

func _ready():
	velocity.y = 1000
func _physics_process(delta):
	
	velocity.y += 3000 * delta
	move_and_slide()
