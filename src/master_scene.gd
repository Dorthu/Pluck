extends Node2D

class_name MasterController

var dialog_controller # a DialogController
var cur_room # a Room, but it's circular dependency to declare that
var camera # a Camera
var inventory # an Inventory
var room_map: Dictionary
var active_item: InventoryItem = null
var clear_active_item := false
var game_state := Dictionary()

func _ready():
	for s in ["prototype-living-room", "test2", "living_room","bedroom","kitchen","cellar"]:
		room_map[s] = ResourceLoader.load('res://scenes/rooms/'+s+'.tscn').instance()
		room_map[s].controller = self
	dialog_controller = get_node('DialogController')
	dialog_controller.controller = self
	camera = get_node("Camera")
	camera.controller = self
	inventory = get_node("Inventory")
	inventory.controller = self
	# TEMP
	game_state['test_state'] = true
	
	# initial room
	change_rooms('bedroom', -400)
	
	# Show initial dialog
	get_node("OpeningDialog").opening_dialog()

func show_dialog(text_pool): # Clickable.DialogTextPool
	if dialog_active():
		return
	inventory.hide()
	dialog_controller.new_dialog(text_pool)

func dialog_finished():
	inventory.show()

func dialog_active():
	return dialog_controller.cur_box != null

func should_pan_camera():
	return active_item == null and not dialog_active()

func should_allow_doors():
	return active_item == null

func get_room_width():
	return cur_room.room_width

func change_rooms(to_room: String, camera_x: float):
	var active_scene = get_node('ActiveScene')
	while len(active_scene.get_children()) > 0:
		active_scene.remove_child(active_scene.get_child(0))
	cur_room = room_map[to_room]
	active_scene.add_child(cur_room)
	
	if camera:
		camera.pan_position = camera_x

func collect_item(item_id, item_texture):
	var item = inventory.make_item(item_id, item_texture)
	inventory.add_item(item)
	
func set_active_item(item: InventoryItem):
	active_item = item
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and active_item != null:
		# don't mark this as handled!
		clear_active_item = true # clear this nomatter what happens
		update()
		
func _process(delta):
	if active_item:
		if clear_active_item:
			active_item = null
			clear_active_item = false
		update()

func _draw():
	if active_item:
		draw_texture(active_item.my_texture, get_global_mouse_position())
