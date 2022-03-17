extends Node2D

var borders = Rect2(4, 4, 117, 117)

onready var tileMap = $TileMap
onready var tileMapOccluder = $TilemapOccluder
export(PackedScene) var Player
export(PackedScene) var Enemy
export(float) var _enemy_spawn_chance

func _ready():
	randomize()
	generate_level()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

func generate_level():
	var walker = Walker.new(Vector2(56, 56), borders)
	var map = walker.walk(800)
	
	var player = Player.instance()
	add_child(player)
	player.position = map.start_pos*32
	
	walker.queue_free()
	for location in map.step_history:
		tileMap.set_cellv(location, -1)
		tileMapOccluder.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
	for location in map.room_history:
		if player.position.distance_to(location*32) > 4*32:
			if randf() <= _enemy_spawn_chance:
				var enemy = Enemy.instance()
				add_child(enemy)
				enemy.position = location*32
