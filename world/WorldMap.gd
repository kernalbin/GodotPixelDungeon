extends Node

class_name WorldMap

var step_history: Array
var start_pos: Vector2
var end_pos: Vector2
var room_history: Array

func _init(step_his: Array, start: Vector2, end: Vector2, room: Array):
	self.step_history = step_his
	self.start_pos = start
	self.end_pos = end
	self.room_history = room
