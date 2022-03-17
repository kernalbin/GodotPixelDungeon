extends KinematicBody2D

onready var _player := get_parent().get_node("Player")
onready var _playerCast := get_node("PlayerCast")
onready var _navigator := get_node("Navigation2D")

enum State {WANDER, FOLLOW}

export var speed = 50
export var friction = 0.8
export var acceleration = 0.1
var velocity = Vector2()
var direction = Vector2()
var state = State.WANDER

func _ready():
	pass

func _physics_process(delta):
	update_visibility()


func update_visibility():
	var _collision_object = _playerCast.get_collider()
	
	if _collision_object == _player:
		self.visible = true
	else:
		self.visible = false
		
	var _direction_to_player = global_position.direction_to(_player.global_position)
	_playerCast.cast_to = _direction_to_player * (32*8)

func _on_PathChange_timeout():
	pass
