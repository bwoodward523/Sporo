extends CanvasLayer

@onready var inventory = $InventoryGui
@onready var player = get_parent().player

func _ready():
	print(player)
	inventory.open()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
