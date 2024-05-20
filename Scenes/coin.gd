extends Area2D

var item_type : int # 0: coin
var tempbal : int
@onready var player = get_parent().get_node("player")
var coin_img = preload("res://Assets/tempcoin.png")
var heart_img = preload("res://Assets/heartdrop.png")
var ammo_img = preload("res://Assets/ammo pickup.png")
var dir: Vector2
var range := Vector2(150,150)
var SPEED = 750
var textures = [coin_img, heart_img, ammo_img]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _physics_process(delta):
	if player.position - position < range:
		dir = (player.position - position).normalized()
		position += dir * SPEED * delta

func _on_body_entered(body):
	$Pickup.play()
	#coin.
	if item_type == 0:
		tempbal = randi_range(1,5)
		Data.balance += tempbal
		print("Coin picked up")
	#heart
	if item_type == 1:
		if player.health <= 15:
			player.health += 1
			player.update_health_ui()
		print("Health picked up")
	#ammo
	if item_type == 2:
		player.Active_Item.CURRENT_AMMO += 300
		print("Ammo picked up")

func _on_pickup_finished():
	queue_free()
