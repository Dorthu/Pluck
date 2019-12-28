extends Node2D

class_name MasterController

var dialog_controller: DialogController
var cur_room # a Room, but it's circular dependency to declare that

var room_map: Dictionary

func _ready():
	for s in ["prototype-living-room", "test2"]:
		room_map[s] = ResourceLoader.load('res://scenes/rooms/'+s+'.tscn').instance()
		room_map[s].controller = self
	change_rooms('prototype-living-room')
	dialog_controller = get_node('DialogController')
	var camera = get_node("Camera")
	camera.controller = self

func show_dialog(line1: String, line2: String, line3: String):
	if dialog_active():
		return
	dialog_controller.show_dialog(line1, line2, line3)
	
func dialog_active():
	return dialog_controller.cur_box != null
	
func get_room_width():
	return cur_room.room_width
	
func change_rooms(to_room: String):
	var active_scene = get_node('ActiveScene')
	while len(active_scene.get_children()) > 0:
		active_scene.remove_child(active_scene.get_child(0))
	cur_room = room_map[to_room]
	active_scene.add_child(cur_room)