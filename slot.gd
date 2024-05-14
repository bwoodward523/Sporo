extends Button

@export var item : Resource

func setItemTexture(texture : Texture):
	get_child(2).Texture = texture

