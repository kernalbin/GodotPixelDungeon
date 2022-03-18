extends KinematicBody2D

onready var _player := get_parent().get_node("Player")
onready var _interestCast := get_node("InterestCast")
onready var _playerCast := get_node("PlayerCast")
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
	
	if state == State.WANDER:
		var dir = position.direction_to(interest)
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
		velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
	elif state == State.IDLE:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	elif state == State.FOLLOW:
		_interestCast.cast_to = _player.position
		_interestCast.force_raycast_update()
		if not _interestCast.get_collider() == _player:
			state = State.IDLE
			find_new_interest()
		else:
			var dir = position.direction_to(interest)
			velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
			velocity.y = lerp(velocity.y, dir.y * speed, acceleration)
		
	if velocity.length() > 0.001:
		move_and_slide(velocity, Vector2.UP)

func look_for_player() -> bool:
	var dir = position.direction_to(interest)
	velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
	velocity.y = lerp(velocity.y, dir.y * speed, acceleration)

func find_new_interest() -> Vector2:
	var _random_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * 1000
	_interestCast.cast_to = _random_dir
	
	while(true):
		_interestCast.cast_to /= 2
		_interestCast.force_raycast_update()
		if not _interestCast.is_colliding():
			return to_global(_interestCast.cast_to)
	print("also bad")
	return Vector2(0,0)

func _on_PathChange_timeout():
	if state == State.FOLLOW: return # Ignore timer if following player
	if randi() % 2: # Change path or idle
		state = State.WANDER
		interest = find_new_interest()
	else:
		state = State.IDLE
		
func _on_see_Player():
	$SeePlayer.start()
	
func _on_lose_Player():
	$SeePlayer.stop()
	$SeePlayer.wait_time = 0.5

func _on_SeePlayer_timeout():
	state = State.FOLLOW
	interest = _player.position
