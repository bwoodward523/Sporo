extends CharacterBody2D

@export var enemy: Resource
@onready var bat = preload("res://Enemies/Scenes/BatBullet.tscn")
@onready var player = get_parent().get_node("player")
@onready var main = get_parent()
var isHurt: bool
var worldBatCount: int
@export var maxBatsInWorld: int

func _ready():
	$HealthComponent.health = enemy.ENEMY_HEALTH
func _physics_process(delta):
	velocity = (player.position - position).normalized() * enemy.ENEMY_SPEED * delta
	move_and_slide()
	if $HealthComponent.isDead:
		queue_free()

func _on_bat_spawn_rate_timeout():
	worldBatCount = 0
	count_bats()
	if worldBatCount < maxBatsInWorld:
		
		var batInstance = bat.instantiate()
		batInstance.position = Vector2(position.x - 20, position.y)
		main.add_child(batInstance, true)
		
		batInstance = bat.instantiate()
		batInstance.position = Vector2(position.x + 20 , position.y)
		main.add_child(batInstance, true)

func count_bats():
	for child in main.get_children():
		if child.name.contains("Bat"):
			worldBatCount+= 1

func _play_hurt():
	pass
func take_damage():
	$HealthComponent.deductHealth()

