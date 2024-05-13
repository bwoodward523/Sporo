extends Resource

class_name ITEM

@export var ITEM_NAME : String
@export var ITEM_TEXTURE : Texture: set = _set_texture, get = _get_texture
@export var QUANTITY : int
@export var HOVER_TEXT : String

func addQuantity(addedQuant):
	QUANTITY += addedQuant

func _set_texture(new : Texture):
	ITEM_TEXTURE = new
func _get_texture():
	return ITEM_TEXTURE
