extends Control

@onready var player = get_parent().get_node("player")
@onready var slots: Array = $CanvasLayer/InventoryGui/NinePatchRect/GridContainer.get_children()

func _ready():
	connectSlots()

func connectSlots():
	for slot in slots:
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func _process(delta):
	if (player.item1 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot/Contains").texture = player.item1.ITEM_TEXTURE
	if (player.item2 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2/Contains").texture = player.item2.ITEM_TEXTURE
	if (player.item3 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3/Contains").texture = player.item3.ITEM_TEXTURE

func onSlotClicked(slot):
	pass
	
