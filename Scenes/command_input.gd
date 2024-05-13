extends Control

@onready var player = get_parent().get_node("player")

func _ready():
	pass

func _process(delta):
	if (player.item1 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot/Contains").texture = player.item1.ITEM_TEXTURE
	if (player.item2 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2/Contains").texture = player.item2.ITEM_TEXTURE
	if (player.item3 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3/Contains").texture = player.item3.ITEM_TEXTURE
