extends Node2D
#@onready var enemy = get_parent().get_node("Enemy")
@onready var enemy = preload("res://Enemies/Scenes/enemy.tscn")
@onready var enemyGnome = preload("res://Enemies/Scenes/enemy_gnome.tscn")
@onready var enemySummoner = preload("res://Enemies/Scenes/batSummoner.tscn")
@onready var enemyMage = preload("res://Enemies/Scenes/EnemyMage.tscn")
@onready var enemyBoss = preload("res://Enemies/Scenes/enemy_boss.tscn")
#@onready var enemyMage = load("res://Scenes/enemymage.tscn")
@onready var main = get_tree().get_current_scene()
@onready var player = get_parent().get_node("player")
@onready var camera = player.get_node("Camera2D")
var canSpawnGnome = true
var enemyInstance
var dirSpawn: int #(1 left) (2 right) (3 up) 4(down)
var enemiesSpawned = 0
@export var enemiesUntilBoss = 100
var enemyKillCount = 0
var canSpawnEnemies = true
var bandaidNoMoreBoss = false
var enemyAliveArray: Array[PackedScene]

var spawnBoss = false
func _ready():
	$Timer.wait_time -= (Data.spawningoffset*0.05)
func _physics_process(delta):
	player = get_parent().get_node("player")
func _on_timer_timeout():
	var viewport = get_viewport()
	var rectangle = viewport.get_visible_rect()
	var rightEnd = rectangle.end
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if rng.randi_range(1,10) == 1 && canSpawnGnome:
		enemyInstance = enemyGnome.instantiate()
	elif rng.randi_range(1,10) == 2:
		enemyInstance = enemySummoner.instantiate()
	elif rng.randi_range(1,10) == 3:
		enemyInstance = enemyMage.instantiate()
	elif canSpawnGnome:
		enemyInstance = enemy.instantiate()
	if enemyKillCount >= enemiesUntilBoss:
		enemyInstance = null
		spawnBoss = true
		enemyKillCount = 0
	if !canSpawnEnemies:
		enemyKillCount = 0
		enemyInstance = null
	if spawnBoss and !bandaidNoMoreBoss:
		enemyInstance = enemyBoss.instantiate()
		enemyInstance.position = Vector2(player.position.x + 400, player.position.y - 400)
		spawnBoss = false
		canSpawnEnemies = false
		bandaidNoMoreBoss = true

	if enemyInstance != null and canSpawnEnemies:
		dirSpawn = rng.randi_range(1,4) #set which side of screen enemy comes from
		if dirSpawn == 1: #left
			var randHeight = rng.randi_range(player.position.y - rightEnd.y/1.25, player.position.y + rightEnd.y/1.25)
			enemyInstance.position = Vector2(player.position.x - rightEnd.x/1.25, randHeight)
		if dirSpawn == 2: # right
			var randHeight = rng.randi_range(player.position.y - rightEnd.y/1.25, player.position.y + rightEnd.y/1.25)
			enemyInstance.position = Vector2(player.position.x + rightEnd.x/1.25, randHeight)
		if dirSpawn == 3: # come from above
			var randWidth = rng.randi_range(player.position.x - rightEnd.x/1.25, player.position.x + rightEnd.x/1.25)
			enemyInstance.position = Vector2(randWidth, player.position.y - rightEnd.y/1.25)
		if dirSpawn == 4: # come from below
			var randWidth = rng.randi_range(player.position.x - rightEnd.x/1.25, player.position.x + rightEnd.x/1.25)
			enemyInstance.position = Vector2(randWidth, player.position.y + rightEnd.y/1.25)

	main.add_child(enemyInstance,true)
	enemiesSpawned += 1
	
	if fmod(enemiesSpawned, 10) == 0 && $Timer.wait_time > 0.1:
		$Timer.wait_time  -= 0.05
func _on_count_gnomes_timeout():
	var gnomeCount = 0
	var world = get_parent()
	var gnomeList: Array[PackedScene]
	

	for gnome in world.get_children():
		if gnome.name.contains("Gnome"):
			gnomeCount += 1
	print("numba of gnomes", gnomeCount)
	if gnomeCount > 10:
		canSpawnGnome = false
	else:
		canSpawnGnome = true


func _on_count_enemies_timeout():
	#print(enemyKillCount)
	pass	
