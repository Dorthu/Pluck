extends Node2D

class_name Room

var controller # MasterController

export var room_width: int

func mouse_position() -> Vector2:
	# returns the mouse position in the room
	var mouse_pos := get_global_mouse_position()
	
	mouse_pos.x -= controller.camera.pan_position
	return mouse_pos
