extends Camera2D

class_name MouseFollowCamera

var PAN_SPEED := .08
var PAN_MARGIN := 250
var Y_CUTOFF := 500

var controller: MasterController
var VIEWPORT_WIDTH := 1020
var pan_position := 0.0

# These are for mobile camera controls, where instead of using the
# mouse position to pan, we use a tap-and-drag interface
var mouse_pressed := false
var dragging := false
var mouse_relative := 0.0
const DRAG_THRESHOLD := 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controller.cutscene_mode:
		return
	
	if not controller.should_pan_camera():
		controller.cur_room.position.x = pan_position
		return
	
	if not controller.is_mobile:
		process_desktop(delta)
	
	# move the camera
	controller.cur_room.position.x = pan_position

func process_desktop(_delta):
	var mouse_pos := get_global_mouse_position()
	
	if mouse_pos.y >= Y_CUTOFF:
		# it's in the inventory or whatever
		return
	
	var mouse_x = mouse_pos.x
	var distance = 0
	var dir := 1
	
	if mouse_x > VIEWPORT_WIDTH - PAN_MARGIN:
		distance = VIEWPORT_WIDTH - mouse_x
		dir = -1
	elif mouse_x < PAN_MARGIN:
		distance = mouse_x
	
	if distance != 0:
		pan_position += (PAN_MARGIN - distance) * PAN_SPEED * dir
	
	fix_bounds()

func _unhandled_input(event):
	if not controller.is_mobile:
		return
	
	if not controller.should_pan_camera():
		return
	
	# this is for mobile only
	if event is InputEventMouseButton:
		if event.pressed:
			if get_global_mouse_position().y > Y_CUTOFF:
				# ignore presses that happen in the inventory panel
				dragging=false
				mouse_pressed=false
				return
			mouse_pressed = true
			dragging = false
			mouse_relative = 0
		else:
			mouse_pressed = false
	elif mouse_pressed and event is InputEventMouseMotion:
		mouse_relative += abs(event.relative.x)
		if mouse_relative > DRAG_THRESHOLD:
			dragging = true
		if dragging:
			pan_position += event.relative.x
			fix_bounds()

# immediately makes the camera respect the bounds of the room.  This
# is needed on some transitions to ensure the camera doesn't stray
# out of bounds
func snap_camera():
	pan_position = controller.cur_room.position.x
	
	fix_bounds()
	controller.cur_room.position.x = pan_position

# fixes the camera to the boundries of the current room.  This is
# a function for the sake of DRY and nothing more.
func fix_bounds():
	if pan_position > 0:
		pan_position = 0
	elif pan_position < -1 * (controller.get_room_width() - VIEWPORT_WIDTH):
		pan_position = -1 * (controller.get_room_width() - VIEWPORT_WIDTH)
