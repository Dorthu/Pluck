extends Camera2D

class_name MouseFollowCamera

var PAN_SPEED := 5
var PAN_MARGIN := 250

var controller: MasterController
const VIEWPORT_WIDTH := 1020


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if controller.dialog_active():
		return
	
	var mouse_x = get_global_mouse_position().x - self.position.x
	
	if mouse_x > get_viewport_rect().size.x - PAN_MARGIN:
		self.position.x += PAN_SPEED
	elif mouse_x < PAN_MARGIN:
		self.position.x -= PAN_SPEED
	
	# check bounds
	if self.position.x < 0:
		self.position.x = 0
	elif self.position.x > controller.get_room_width() - VIEWPORT_WIDTH:
		self.position.x = controller.get_room_width() - VIEWPORT_WIDTH
	
	position = self.position
	
	
	
