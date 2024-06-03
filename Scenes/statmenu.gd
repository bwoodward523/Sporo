extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var total = Data.liches + Data.bats + Data.grunts + Data.gnomes + Data.mages + Data.summoners
	var liches = Data.liches
	var grunts = Data.grunts
	var bats = Data.bats 
	var gnomes = Data.gnomes
	var mages = Data.mages
	var sum = Data.summoners
	
	$HBoxContainer/VBoxContainer/batskilled.text = "Forest Bats Slain: " + str(bats)
	$HBoxContainer/VBoxContainer/summonerskilled.text = "Forest Summoners Slain: " + str(sum)
	$HBoxContainer/VBoxContainer/mageskilled.text = "Forest Mages Slain: " + str(mages)
	$HBoxContainer/VBoxContainer/gnomeskilled.text = "Forest Gnomes Slain: " + str(gnomes)
	$HBoxContainer/VBoxContainer/gruntskilled.text = "Forest Grunts Slain: " + str(grunts)
	$HBoxContainer/VBoxContainer/bosseskilled.text = "Forest Liches Slain: " + str(liches)
	$HBoxContainer/VBoxContainer/totalenims.text = "Total Enemies Slain: " + str(total)
