extends Control

signal opened
signal closed
var isOpen: bool = false
func _ready():
	$NinePatchRect/GridContainer/ButtonBox/Key.text = "1"
	$NinePatchRect/GridContainer/ButtonBox2/Key.text = "2"
	$NinePatchRect/GridContainer/ButtonBox3/Key.text = "3"
# Open/close inventory
func open():
	visible = true
	isOpen = true
	opened.emit()
func close():
	visible = false
	isOpen = false
	closed.emit()

