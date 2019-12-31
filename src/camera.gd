extends Camera2D

class_name MouseFollowCamera

var PAN_SPEED := 5
var PAN_MARGIN := 250
var Y_CUTOFF := 500

var controller: MasterController
const VIEWPORT_WIDTH := 1020
var pan_position := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controller.dialog_active():
		return
	
	var mouse_pos := get_global_mouse_position()
	
	if mouse_pos.y >= Y_CUTOFF:
		# it's in the inventory or whatever
		return
	
	var mouse_x = mouse_pos.x
	
	if mouse_x > get_viewport_rect().size.x - PAN_MARGIN:
		pan_position -= PAN_SPEED
	elif mouse_x < PAN_MARGIN:
		pan_position += PAN_SPEED
	
	#position = self.position
	if pan_position > 0:
		pan_position = 0
	elif pan_position < -1 * (controller.get_room_width() - VIEWPORT_WIDTH):
		pan_position = -1 * (controller.get_room_width() - VIEWPORT_WIDTH)
	
	controller.cur_room.position.x = pan_position
	
	
	
