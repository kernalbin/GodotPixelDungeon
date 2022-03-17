extends TileMap

onready var _borders = get_parent().borders
onready var _tiles = tile_set
onready var _id = 0
onready var _rect = tile_set.tile_get_region(_id)


func _ready():
	for x in _borders.size.x:
		for y in _borders.size.y:
			if randf() <= .3:
				set_cell(x, y, _id, false, false, false, _get_subtile_coord(_tiles, _rect, _id))
			else:
				set_cell(x, y, _id)


func _get_subtile_coord(tiles, rect, id):
	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	return Vector2(x, y)
