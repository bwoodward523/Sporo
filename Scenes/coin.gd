extends Area2D

var temp : int
var item_type : int # 0: coin
var tempbal : int
@onready var player = get_parent().get_node("player")
var shroomlow = preload("res://Assets/low_value_mushroom.png")
var shroommid = preload("res://Assets/med_value_mushroom.png")
var shroomhigh = preload("res://Assets/high_value_mushroom.png")
var heart_img = preload("res://Assets/heartdrop.png")
var ammo_img = preload("res://Assets/ammo pickup.png")
var dir: Vector2
var range1 := Vector2(150,150)
var SPEED = 750
var textures = [shroomlow, shroommid, shroomhigh, heart_img, ammo_img]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textures[item_type]

func _physics_process(delta):
	# Pathfinding for coins to search for player
	if player.position - position < range1:
		dir = (player.position - position).normalized()
		position += dir * SPEED * delta

@warning_ignore("unused_parameter", "narrowing_conversion")
func _on_body_entered(body):
	$Pickup.play()
	#coin.
	if item_type < 3:
		tempbal = randi_range(7,15)*(1 + (Data.coinmultiplier*0.1))*(item_type+1)
		Data.balance += tempbal
		print("Coin picked up")
	#heart
	if item_type == 3:
		if player.health <= 15:
			player.health += 1
			player.update_health_ui()
		print("Health picked up")
	#ammo
	if item_type == 4:
		temp = player.Active_Item.CURRENT_AMMO + (player.Active_Item.MAX_AMMO * 0.2)
		if temp > player.Active_Item.MAX_AMMO:
			player.Active_Item.CURRENT_AMMO = player.Active_Item.MAX_AMMO
		else:
			player.Active_Item.CURRENT_AMMO += (player.Active_Item.MAX_AMMO * 0.2)
		player.update_ammo_ui()
		print("Ammo picked up")

func _on_pickup_finished():
	queue_free()
