extends Control

signal opened
signal closed
var isOpen: bool = false

func open():
	
	isOpen = true
	opened.emit()
func close():

	isOpen = false
	closed.emit()

