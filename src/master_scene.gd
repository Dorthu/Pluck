extends Node2D

class_name MasterController

var dialog_controller # a DialogController
var cur_room # a Room, but it's circular dependency to declare that
var camera # a Camera
var inventory # an Inventory
var hint_icon # a HintIcon
var room_map: Dictionary
var active_item: InventoryItem = null
var clear_active_item := false
var game_state := Dictionary()
var stop_camera := true
var on_dialog_finished

var hud_root: Node2D

var HINT_ICON_TEMPLATE = ResourceLoader.load("res://scenes/ui/ClickHint.tscn")
var CUTSCENE_TEMPLATE = ResourceLoader.load("res://scenes/cutscene/intro-outro.tscn")
var cutscene_mode := false

var is_mobile := false

func _ready():
	dialog_controller = get_node('DialogController')
	dialog_controller.controller = self
	camera = get_node("Camera")
	camera.controller = self
	hud_root = get_node("HUDSpacer")
	inventory = hud_root.get_node("Inventory")
	inventory.controller = self
	hint_icon = hud_root.get_node("HintIcon")
	
	# set up intro cutscene
	var active_scene = get_node("ActiveScene")
	var cutscene = CUTSCENE_TEMPLATE.instance()
	cutscene.start_cutscene(1)
	cutscene_mode = true
	cutscene.controller = self # for callback
	active_scene.add_child(cutscene)
	get_node("OpeningDialog").hide()
	hide_ui()
	
	# setup for mobile support
	# this all assumes we're only doing export for web, which
	# is true for now.  Wrap this in a platform check if we decide
	# to export to other platforms later
	var value = JavaScript.eval("""
		// this might need to be changed, I hear it's deprecated
		var result = (typeof window.orientation !== 'undefined');
		result;
	""")
	if value:
		# flag that this is a mobile session so we can handle it
		# accordingly elsewhere
		is_mobile = true
		JavaScript.eval("""
			alet('were in mobile mode now!');
		""")
		# what are the screen dimensions in this mobile browser?
		#var screen_width = JavaScript.eval("innerWidth")
		var screen_height = JavaScript.eval("innerHeight")
		# 1024 x 600 are the intended dimensions
		var height_scale = screen_height/600
		var new_dimensions = Vector2(1024, 600) / height_scale
		JavaScript.eval("""
			var canvas = document.getElementById('canvas');
			canvas.width = %s;
			canvas.height = %s;
		""" % [new_dimensions.x, new_dimensions.y])
		# we're adding the pan margin so you can't over-scroll
		camera.VIEWPORT_WIDTH = new_dimensions.y + camera.PAN_MARGIN
		camera.snap_camera() # make sure we're in frame
		hud_root.position.x = camera.VIEWPORT_WIDTH / 2
		# 402 is half the dialog box's width
		dialog_controller.BOX_POS.x = hud_root.position.x - 402

func show_dialog(text_pool, on_finished=null): # Clickable.DialogTextPool
	if dialog_active():
		return
	hide_ui()
	dialog_controller.new_dialog(text_pool)
	on_dialog_finished = on_finished

func dialog_finished():
	show_ui()
	if on_dialog_finished:
		on_dialog_finished.dialog_finished()
		on_dialog_finished = null

func dialog_active():
	return dialog_controller.cur_box != null

func should_pan_camera():
	if stop_camera:
		return false
	return not cutscene_mode and active_item == null and not dialog_active()

func should_allow_doors():
	return (active_item == null and not dialog_active() 
			and game_state_active("showed_opening_dialog"))

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
		camera.fix_bounds()

func collect_item(item_id, item_texture):
	var item = inventory.make_item(item_id, item_texture)
	inventory.add_item(item)
	
func set_active_item(item: InventoryItem):
	if active_item and item == null:
		active_item.stop_being_active()
	active_item = item
	
func set_game_state(state: String):
	game_state[state] = true

func game_state_active(state: String):
	return state in game_state
	
func _unhandled_input(event):
	if cutscene_mode:
		return # handled by cutscene orchestrator
	
	#if event is InputEventKey and event.pressed:
	#	if event.scancode == KEY_E:
	#		hide_ui()
	#	elif event.scancode == KEY_R:
	#		show_ui()
		
	
	if event is InputEventMouseButton and active_item != null:
		# this is backward on mobile so that the more natural tap-and-drag works
		if (not is_mobile and event.pressed) or (is_mobile and not event.pressed):
			# don't mark this as handled!
			clear_active_item = true # clear this nomatter what happens
			update()

func _process(_delta):
	if active_item:
		if clear_active_item:
			set_active_item(null)
			clear_active_item = false
		update()

func _draw():
	if active_item:
		draw_texture(active_item.my_texture, get_global_mouse_position())

func show_click_hints():
	# when called, this function adds and makes visible a "click hint"
	# on each clickable element on the screen.  This is intended to
	# help players find what is interactable and help avoid pixel-
	# hunting.
	if cutscene_mode:
		return
	
	for node in cur_room.get_children():
		if not node is Clickable or not node.visible:
			continue
		
		var existing_hint_node = node.get_node("ClickHint")
		if existing_hint_node:
			existing_hint_node.show()
		else:
			if not node.before_backpack:
				if not inventory.has_item("backpack"):
					continue
			var new_hint_node = HINT_ICON_TEMPLATE.instance()
			new_hint_node.name = "ClickHint"
			new_hint_node.z_index = 15
			node.add_child(new_hint_node)

func hide_click_hints():
	# when called, this function hides all click hitns
	for node in cur_room.get_children():
		var existing_hint_node = node.get_node("ClickHint")
		if existing_hint_node:
			existing_hint_node.hide()

func hide_ui():
	hud_root.hide()

func show_ui():
	hud_root.show()

func intro_cutscene_callback(cso: CutsceneOrchestrator):
	# the intro cutscene hides the loading of all rooms, so we need
	# to finish setting them up now.
	for s in room_map.values():
		s.controller = self
	
	# setup the first room
	change_rooms('bedroom', -400)
	
	# this is called when the intro cutscene is done to enable the game
	show_ui()
	get_node("OpeningDialog").show()
	change_rooms("bedroom", -400)
	cutscene_mode = false

func show_outro_cutscene():
	# sets up and starts the outro cutscene.  This ends the game.
	var active_scene = get_node("ActiveScene")
	while len(active_scene.get_children()) > 0:
		active_scene.remove_child(active_scene.get_child(0))
	cutscene_mode = true
	var cutscene = CUTSCENE_TEMPLATE.instance()
	cutscene.controller = self # for callback
	active_scene.add_child(cutscene)
	cutscene.start_cutscene(2)
	hide_ui()

func click_should_interact(event):
	if is_mobile:
		return (not event.pressed and not camera.dragging)
	else:
		return event.pressed
