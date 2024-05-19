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



func onSlotClicked(slot):
	print(slot.name)
	var tempSlot1 = player.item1
	var tempSlot2 = slot.item
	player.item1 = tempSlot2
	slot.item =  tempSlot1
	if(slot.name == "Slot2"):
		player.item2 = tempSlot1
	if(slot.name == "Slot3"):
		player.item3 = tempSlot1


func _input(event):
	if get_tree().get_current_scene().get_name() != "HubWorld":
		if event is InputEventKey and Input.is_action_pressed("item_one") and player.item1 != null:
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		if event is InputEventKey and Input.is_action_pressed("item_two") and player.item2 != null:
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		if event is InputEventKey and Input.is_action_pressed("item_three") and player.item3 != null:	
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		#Update weapon parameters to match selected weapon	
	
	
	if (player.item1 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot/Contains").texture = player.item1.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot").item = player.item1
	if (player.item2 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2/Contains").texture = player.item2.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2").item = player.item2
	if (player.item3 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3/Contains").texture = player.item3.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3").item = player.item3
