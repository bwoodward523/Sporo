extends Node2D


@export var MAXHEALTH = 5
@onready var health = MAXHEALTH
var isDead = false

@onready var parent = get_parent() 

func deductHealth():
	health -= 1
	if health <= 0:
		isDead = true
	if isDead:
		parent.queue_free()
