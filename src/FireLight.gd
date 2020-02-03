extends Light2D
#  A flickering fire light
class_name FireLight

var base_offset: Vector2
var base_position: Vector2
var total_time := 0.0

func _ready():
	base_offset = self.offset
	base_position = self.position

func _process(delta):
	# TODO - make this flicker like fire!
	total_time += delta
	self.energy = (sin(total_time*2) *.3)+.75
	var frame_transform := Vector2(sin(total_time*3.5)*10, cos(total_time*1.5)*10)
	
	self.offset = base_offset + frame_transform
	self.position = base_position - frame_transform
