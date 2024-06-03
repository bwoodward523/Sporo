extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$knighttalking.text = "I heard you've been busy out in the forest! If you're looking to increase your effectiveness, my services may be of interest..."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Display what the current spawining offset is
	var spawningpercert = Data.spawningoffset*5
	var cost = 250 * (Data.spawningoffset + 1)
	$VBoxContainer/HBoxContainer/SpawningLabel.text = "Increase spawn rate: +" + str(spawningpercert) + "%,     "+str(cost)+" Coins"
