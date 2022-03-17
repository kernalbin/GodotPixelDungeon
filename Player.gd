extends KinematicBody2D

export var _player_speed = 200

onready var camera = $Camera2D

func _physics_process(_delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var movement_vector = Vector2(x_input, y_input).normalized() * _player_speed
	move_and_slide(movement_vector)

