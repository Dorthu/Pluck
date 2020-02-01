extends Node2D

class_name Bumble

# The bumble avoids your mouse unless the active item is
# the one it wants; if it is, the bumble comes right to
# you ands gives you the honeycomb
var controller # The MasterController 

const MOVE_SPEED = 500
const MAX_SPEED := 500.0
const MAX_TURN := .2
const BASE_ACCEL := 20.0

var room_center: Vector2
var velocity := Vector2(1, 1)


func _ready():
	controller = get_tree().get_root().get_children()[0]
	room_center = Vector2(get_parent().room_width/2, 300)


func _process(delta):
	# find where we want to go
	var goal := room_center # we just like buzzing around here
	var mouse_pos = get_global_mouse_position()
	var avoid_mouse = true
	var accel = BASE_ACCEL
	
	# maybe we want to go to the mouse instead of there
	if controller.active_item != null and controller.active_item.id == 'liquor':
		avoid_mouse = false
		goal = mouse_pos
	
	var vector_to_target := goal - self.position
	
	# oh no wait we want to avoid the mouse
	if avoid_mouse:
		var distance_to_mouse = self.position.distance_to(mouse_pos)
		
		# it's too close - run (fly?) away!
		if distance_to_mouse < 200:
			# flying away is deciding we want to fly _exactly away_
			vector_to_target = (mouse_pos - self.position) * -1
			accel = 200 - distance_to_mouse # speed up flying away
	
	# find out how hard we want to turn, and how hard we can turn
	var desired_turn := vector_to_target.normalized()
	var actual_turn := desired_turn
	actual_turn.x = clamp(actual_turn.x, -MAX_TURN, MAX_TURN)
	actual_turn.y = clamp(actual_turn.y, -MAX_TURN, MAX_TURN)
	
	# slow down if we're turning very hard
	if desired_turn.angle() > PI/2:
		accel /= desired_turn.angle()
	
	# update our velocity
	velocity += actual_turn * accel
	velocity = velocity.clamped(MAX_SPEED)
	
	# actually move in the direction we're going
	self.position += velocity * delta
