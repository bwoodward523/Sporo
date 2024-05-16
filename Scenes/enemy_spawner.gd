extends Node2D
#@onready var enemy = get_parent().get_node("Enemy")
@onready var enemy = load("res://Scenes/enemy.tscn")
@onready var enemyGnome = load("res://Enemies/Scenes/enemy_gnome.tscn")
#@onready var enemyMage = load("res://Scenes/enemymage.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_node("player")
@onready var camera = player.get_node("Camera2D")
var canSpawnGnome = true
var enemyInstance
var dirSpawn: int #(1 left) (2 right) (3 up) 4(down)
func _on_timer_timeout():
	var viewport = get_viewport()
	var rectangle = viewport.get_visible_rect()
	var rightEnd = rectangle.end
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if rng.randi_range(1,2) == 2:
		enemyInstance = enemy.instantiate()
	elif canSpawnGnome:
		enemyInstance = enemyGnome.instantiate()
	if enemyInstance != null:
		dirSpawn = rng.randi_range(1,4) #set which side of screen enemy comes from
		if dirSpawn == 1: #left
			var randHeight = rng.randi_range(player.position.y - rightEnd.y/2, player.position.y + rightEnd.y/2)
			enemyInstance.position = Vector2(player.position.x - rightEnd.x/2, randHeight)
		if dirSpawn == 2: # right
			var randHeight = rng.randi_range(player.position.y - rightEnd.y/2, player.position.y + rightEnd.y/2)
			enemyInstance.position = Vector2(player.position.x + rightEnd.x/2, randHeight)
		if dirSpawn == 3: # come from above
			var randWidth = rng.randi_range(player.position.x - rightEnd.x/2, player.position.x + rightEnd.x/2)
			enemyInstance.position = Vector2(randWidth, player.position.y - rightEnd.y/2)
		if dirSpawn == 4: # come from below
			var randWidth = rng.randi_range(player.position.x - rightEnd.x/2, player.position.x + rightEnd.x/2)
			enemyInstance.position = Vector2(randWidth, player.position.y + rightEnd.y/2)
		#print(player.position)
		
	
	main.add_child(enemyInstance,true)

func _on_count_gnomes_timeout():
	var gnomeCount = 0
	var world = get_parent()
	var gnomeList: Array[PackedScene]
	

	for gnome in world.get_children():
		if gnome.name.contains("Gnome"):
			gnomeCount += 1
	print("numba of gnomes", gnomeCount)
	if gnomeCount > 1:
		canSpawnGnome = false
	else:
		canSpawnGnome = true
