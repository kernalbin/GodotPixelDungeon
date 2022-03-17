extends Control

onready var _fps_label = $FPS

func _on_UpdateDebug_timeout():
	_fps_label.text = str(Performance.get_monitor(Performance.TIME_FPS))
