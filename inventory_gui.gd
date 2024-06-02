extends Control

signal opened
signal closed
var isOpen: bool = false

# Open/close inventory
func open():
	$NinePatchRect/GridContainer/ButtonBox/Key.text = "1"
	$NinePatchRect/GridContainer/ButtonBox2/Key.text = "2"
	$NinePatchRect/GridContainer/ButtonBox3/Key.text = "3"
	visible = true
	isOpen = true
	opened.emit()
func close():
	visible = false
	isOpen = false
	closed.emit()

