extends Camera2D

class_name MouseFollowCamera

var PAN_SPEED := 5
var PAN_MARGIN := 250

var mouse_pos = Vector2(120, 120)
var controller: MasterController
const VIEWPORT_WIDTH := 1020

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if controller.dialog_active():
		return
	
	if mouse_pos.x > get_viewport_rect().size.x - PAN_MARGIN:
		self.position.x += PAN_SPEED
	elif mouse_pos.x < PAN_MARGIN:
		self.position.x -= PAN_SPEED
	
	# check bounds
	if self.position.x < 0:
		self.position.x = 0
	elif self.position.x > controller.get_room_width() - VIEWPORT_WIDTH:
		self.position.x = controller.get_room_width() - VIEWPORT_WIDTH
	
	position = self.position
	
	
	
