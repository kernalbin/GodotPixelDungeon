extends KinematicBody2D

onready var _player := get_parent().get_node("Player")
onready var _playerCast := get_node("PlayerCast")
onready var _interestCast := get_node("InterestCast")
onready var _world := get_parent()

enum State {IDLE, WANDER, FOLLOW}

export var speed = 50
export var friction = 0.8
export var acceleration = 0.1
var interest = Vector2()
var state = State.IDLE
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	update_visibility()
	
	if state == State.WANDER:
		var dir = position.direction_to(interest)
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
		
	elif state == State.IDLE:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
		
	if velocity.length() > 0.001:
		move_and_slide(velocity, Vector2.UP)


func update_visibility():
	var _collision_object = _playerCast.get_collider()
	
	if _collision_object == _player:
		self.visible = true
	else:
		self.visible = false
		
	var _direction_to_player = global_position.direction_to(_player.global_position)
	_playerCast.cast_to = _direction_to_player * (32*8)

func find_new_interest() -> Vector2:
	var _random_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * 1000
	_playerCast.cast_to = _random_dir
	_playerCast.force_raycast_update()
	while(true):
		_playerCast.cast_to /= 2
		_playerCast.force_raycast_update()
		if not _playerCast.is_colliding():
			return to_global(_playerCast.cast_to)
	print("also bad")
	return Vector2(0,0)

func _on_PathChange_timeout():
	if state == State.FOLLOW: return # Ignore timer if following player
	if randi() % 2: # Change path or idle
		state = State.WANDER
		interest = find_new_interest()
		print(interest)
	else:
		state = State.IDLE
