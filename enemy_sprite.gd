extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mat = material as ShaderMaterial
export var _blur_distance = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true
	frame = randi() & frames.get_frame_count(frames.to_string())-1


func _process(delta):
	mat.set_shader_param("dir", Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()*_blur_distance)
