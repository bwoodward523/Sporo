extends Control

@onready var player = get_parent().get_node("player")
#@onready var slots: Array = $CanvasLayer/InventoryGui/NinePatchRect/GridContainer.get_children()
#
#func _ready():
	#connectSlots()
	#
#
#func connectSlots():
	#for slot in slots:
		#var callable = Callable(onSlotClicked)
		#callable = callable.bind(slot)
		#slot.pressed.connect(callable)
#
#
#
#func onSlotClicked(slot):
	#print(slot.name)
	#var tempSlot1 = player.item1
	#var tempSlot2 = slot.item
	#player.item1 = tempSlot2
	#slot.item =  tempSlot1
	#if(slot.name == "Slot2"):
		#player.item2 = tempSlot1
	#if(slot.name == "Slot3"):
		#player.item3 = tempSlot1


func _input(event):
	# If not in the hub, allow player to change weapons
	if get_tree().get_current_scene().get_name() != "HubWorld":
		print(player.Active_Item)
		# Item Slot One
		if event is InputEventKey and Input.is_action_pressed("item_one") and player.item1 != null and player.Active_Item != get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot").item:
			print("making it here?")
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		# Item Slot Two
		if event is InputEventKey and Input.is_action_pressed("item_two") and player.item2 != null and player.Active_Item != get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2").item:
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		# Item Slot Three
		if event is InputEventKey and Input.is_action_pressed("item_three") and player.item3 != null and player.Active_Item != get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3").item:
			player.Active_Item = get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3").item
			print("New Item Selected: ", player.Active_Item.ITEM_NAME)
			player.get_node("Sprite2D").get_child(0).switch_weapon()
			player.update_ammo_ui()
		#Update weapon parameters to match selected weapon
	
	# If the player does not have an empty slot, make sure that the slot gets filled with the correct item/texture
	if (player.item1 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot/Contains").texture = player.item1.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot").item = player.item1
	if (player.item2 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2/Contains").texture = player.item2.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot2").item = player.item2
	if (player.item3 != null):
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3/Contains").texture = player.item3.ITEM_TEXTURE
		get_node("CanvasLayer/InventoryGui/NinePatchRect/GridContainer/Slot3").item = player.item3
