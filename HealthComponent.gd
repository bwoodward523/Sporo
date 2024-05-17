extends Node2D

@onready var MAXHEALTH = 2
@onready var health:int
@onready var isDead = false

@onready var parent = get_parent() 


func deductHealth():
	health -= 1
	if health <= 0:
		isDead = true
	#if isDead:
		#parent.queue_free()
