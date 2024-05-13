extends Node2D
@onready var raindrop = load("res://raindrop.tscn")
@onready var player = get_node("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rectangle = get_viewport().get_visible_rect()
	var screenWidth = rectangle.end
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in 0:
		if rng.randi_range(1, 2) == 2:
			var instance = raindrop.instantiate()
			var randWidth = rng.randi_range(player.position.x - screenWidth.x/2, player.position.x + screenWidth.x/2)
			instance.position = Vector2(randWidth, player.position.y - screenWidth.y/2)
			add_child(instance)
	

