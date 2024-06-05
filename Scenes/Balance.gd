extends Label
@onready var player = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	# Get balance from Data and display it
	var balance = Data.balance
	
	text = "Balance: "+str(balance)
