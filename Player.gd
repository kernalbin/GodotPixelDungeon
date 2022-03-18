extends KinematicBody2D

export var _player_speed = 200

onready var camera = $Camera2D

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(_delta):
	_update_visibility()	
	
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var movement_vector = Vector2(x_input, y_input).normalized() * _player_speed
	move_and_slide(movement_vector)

func _update_object_visibility(object: Node2D):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, object.position)
	if result:
		if result.collider.is_in_group("visibility_changing"):
			result.collider.visible = true
		else:
			object.visible = false
			
	
	
	
func _get_visibility_changing_objects() -> Array:
	return get_tree().get_nodes_in_group("visibility_changing")
	
func _update_visibility():
	for inst in _get_visibility_changing_objects():
		_update_object_visibility(inst)
