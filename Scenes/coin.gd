extends Area2D

var item_type : int # 0: coin

@onready var player = get_parent().get_node("player")
var coin_img = preload("res://Assets/tempcoin.png")
var dir: Vector2
var range := Vector2(150,150)
var SPEED = 750
var textures = [coin_img]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _physics_process(delta):
	if player.position - position < range:
		dir = (player.position - position).normalized()
		position += dir * SPEED * delta

func _on_body_entered(body):
	#coin.
	if item_type == 0:
		player.balance += 1
		print("Coin picked up")
	#delete item
	queue_free()
