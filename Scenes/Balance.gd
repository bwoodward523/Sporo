extends Label
@onready var player = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var balance = player.balance
	
	text = "Balance: "+str(balance)
