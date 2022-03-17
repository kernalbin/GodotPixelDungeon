extends KinematicBody2D

onready var _player = get_parent().get_node("Player")
onready var _playerCast = get_node("PlayerCast")

func _ready():
	_playerCast.add_exception(get_parent().get_node("TilemapOccluder"))
	_playerCast.add_exception(get_parent().get_node("Background"))

func _physics_process(delta):
	var _collision_object = _playerCast.get_collider()
	
	if _collision_object == _player:
		self.visible = true
	else:
		self.visible = false
		
	var _direction_to_player = global_position.direction_to(_player.global_position)
	_playerCast.cast_to = _direction_to_player * (32*8)
