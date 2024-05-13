extends TextureRect

@export var MY_ITEM : Resource

@onready var MyLabel = $RichTextLabel

func _setItem(newItem : Resource):
	MY_ITEM = newItem
	self.texture = MY_ITEM.getTexture()
	
