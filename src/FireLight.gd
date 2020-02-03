extends Light2D
#  A flickering fire light
class_name FireLight

var total_time := 0.0

func _process(delta):
	# TODO - make this flicker like fire!
	total_time += delta
	self.energy = (sin(total_time*2) + 1)/2
