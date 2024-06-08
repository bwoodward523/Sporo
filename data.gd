extends Node

# File Path for stored data
var save_path = "user://variable.save"

# Data to store, made export variables for testing
@export var balance : int
@export var hat : Texture2D
@export var item1 : Resource
@export var item2 : Resource
@export var item3 : Resource
@export var hat_id : int
@export var item1_id : int
@export var item2_id : int
@export var item3_id : int
@export var liches : int
@export var bats : int
@export var gnomes : int
@export var grunts : int
@export var summoners : int
@export var mages : int
@export var spawningoffset : int
@export var coinmultiplier : int

func _on_game_save():
	save()

func _on_game_load():
	load_data()

func save():
	# Open Save file
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	print("Items saved: ", balance," ", hat_id," ", item1_id," ", item2_id," ", item3_id," ",
	 liches," ", bats," ", gnomes," ", grunts," ", summoners," ", mages, " ", spawningoffset, " ", coinmultiplier)
	# Save values onto the file/overwrite existing stored values
	file.store_var(balance)
	file.store_var(hat_id)
	file.store_var(item1_id)
	file.store_var(item2_id)
	file.store_var(item3_id)
	file.store_var(liches)
	file.store_var(bats)
	file.store_var(gnomes)
	file.store_var(grunts)
	file.store_var(summoners)
	file.store_var(mages)
	file.store_var(spawningoffset)
	file.store_var(coinmultiplier)
func load_data():
	# Check if files exists
	if FileAccess.file_exists(save_path):
		# If file exists, grab all values from file
		var file = FileAccess.open(save_path, FileAccess.READ)
		balance = file.get_var()
		hat_id = file.get_var()
		item1_id = file.get_var()
		item2_id = file.get_var()
		item3_id = file.get_var()
		liches = file.get_var()
		bats = file.get_var()
		gnomes = file.get_var()
		grunts = file.get_var()
		summoners = file.get_var()
		mages = file.get_var()
		spawningoffset = file.get_var()
		coinmultiplier = file.get_var()
		print("Items Loaded: ", balance," ", hat_id," ", item1_id," ", item2_id," ", item3_id," ",
	 liches," ", bats," ", gnomes," ", grunts," ", summoners," ", mages, " ", spawningoffset, " ", coinmultiplier)
	else:
		# If file dne, set all stored values to zero initially
		print("No Data Saved")
		balance = 0
		hat_id = 0
		item1_id = 0
		item2_id = 0
		item3_id = 0
		liches = 0
		bats = 0
		gnomes = 0
		grunts = 0
		summoners = 0
		mages = 0
		spawningoffset = 0
		coinmultiplier = 0
