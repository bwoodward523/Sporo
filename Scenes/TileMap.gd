extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 30
var height = 30
@onready var player = get_parent().get_node("player")

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	z_index = player.z_index - 2



func _process(delta):
	generate_chunk(player.position)
	
func generate_chunk(position):
	
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 +y)*20
			var temp = temperature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 +y)*20
			var alt = altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 +y)*20
			set_cell(0, Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2+y), 0, Vector2(round((moist+10)/10), round((temp+10)/10)))
