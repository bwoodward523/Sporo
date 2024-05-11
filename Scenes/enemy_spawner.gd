extends Node2D
#@onready var enemy = get_parent().get_node("Enemy")
@onready var enemy = load("res://Scenes/enemy.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_node("player")
@onready var camera = player.get_node("Camera2D")
const INT32_MIN = -(1 << 31) # -2147483648
const INT32_MAX = (1 << 31) - 1 # 2147483647
var enemyInstance

func _on_timer_timeout():
	var viewport = get_viewport()
	var rectangle = viewport.get_visible_rect()
	var rightEnd = rectangle.end
	print(rightEnd)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	enemyInstance = enemy.instantiate()
	if rng.randi_range(1,2) == 1:
		var side = rng.randi_range(1,2)
		var dirSpawn = 0
		if side == 1:
			dirSpawn = 1
		else:
			dirSpawn = -1
		var randHeight = rng.randi_range(player.position.y - rightEnd.y/2, player.position.y + rightEnd.y/2)
		enemyInstance.position = Vector2(dirSpawn * (player.position.x + rightEnd.x/2), randHeight)
	else:
		var side = rng.randi_range(1,2)
		var dirSpawn = 0
		if side == 1:
			dirSpawn = 1
		else:
			dirSpawn = -1
		var randWidth = rng.randi_range(player.position.x - rightEnd.x/2, player.position.x + rightEnd.x/2)
		enemyInstance.position = Vector2(randWidth, dirSpawn * (player.position.y + rightEnd.y/2))

	#enemyInstance.position = Vector2(player.position.x + rightEnd.x/2, player.position.y)
	print(enemyInstance.name)
	
	
	main.add_child(enemyInstance,true)
