extends Label

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get ammo from Data file and display it
	var ammo = parent.Active_Item.CURRENT_AMMO
	text = "Ammo: "+str(ammo)
