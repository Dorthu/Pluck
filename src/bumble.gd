extends Node2D

class_name Bumble

# The bumble avoids your mouse unless the active item is
# the one it wants; if it is, the bumble comes right to
# you ands gives you the honeycomb
var controller # The MasterController 

const MOVE_SPEED = 500
var room_center: Vector2
var velocity := Vector2(0, -1)

func _ready():
	controller = get_tree().get_root().get_children()[0]
	room_center = Vector2(get_parent().room_width/2, 300)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	# if I'm on the screen, what am I doing?
	if controller.active_item != null and controller.active_item.id == 'liquor':
		# go toward the mouse
		velocity = (mouse_pos - self.position).normalized()
	else:
		# if it's not near me, bumble around
		var distance := self.position.distance_to(mouse_pos)
		
		if distance < 200:
			velocity = (self.position - mouse_pos).normalized()
		else:
			velocity = (Vector2(500, 300) - self.position).normalized()
	
	self.position += velocity*MOVE_SPEED*delta