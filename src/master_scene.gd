extends Node2D

class_name MasterController

var dialog_controller: DialogController
var cur_room # a Room, but it's circular dependency to declare that

func _ready():
	var s = ResourceLoader.load('res://scenes/rooms/prototype-living-room.tscn')
	var scene_instance = s.instance()
	scene_instance.controller = self
	cur_room = scene_instance
	get_node('ActiveScene').add_child(scene_instance)
	dialog_controller = get_node('DialogController')
	var camera = get_node("Camera")
	camera.controller = self

func show_dialog(text: String):
	if dialog_active():
		return
	dialog_controller.show_dialog(text)
	
func dialog_active():
	return dialog_controller.cur_box != null
	
func get_room_width():
	return cur_room.room_width