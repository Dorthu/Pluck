extends Camera2D

class_name MouseFollowCamera

var PAN_SPEED := 5
var PAN_MARGIN := 250

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_pos = Vector2(120, 120)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if mouse_pos.x > get_viewport_rect().size.x - PAN_MARGIN:
		self.position.x += PAN_SPEED
	elif mouse_pos.x < PAN_MARGIN:
		self.position.x -= PAN_SPEED
		
	position = self.position
	
	
	
