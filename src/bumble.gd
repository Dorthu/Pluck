extends Node2D

class_name Bumble

# The bumble avoids your mouse unless the active item is
# the one it wants; if it is, the bumble comes right to
# you ands gives you the honeycomb
var controller # The MasterController 

const MOVE_SPEED = 500
const MIN_SPEED := 20.0
const MAX_SPEED := 500.0
var room_center: Vector2
var velocity := Vector2(0, -1)

var angle := 1.57
var cvelocity := 1.0
const MAX_TURN := 3.0

func _ready():
	controller = get_tree().get_root().get_children()[0]
	room_center = Vector2(get_parent().room_width/2, 300)

func old_process(delta):
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

func _process(delta):
	# find where we want to go
	var goal := Vector2(500, 300) # arbitrary point to buzz around
	var mouse_pos = get_global_mouse_position()
	var avoid_mouse = true
	
	# maybe we want to go to the mouse instead of there
	if controller.active_item != null and controller.active_item.id == 'liquor':
		avoid_mouse = false
		goal = mouse_pos
	
	# TODO: I _think_ this is where the issue is
	# right now we're getting stuck looping around random points
	# and I think it's because this angle isn't correct
	var angle_to_goal := (goal - self.position).normalized().angle()
	
	# oh no wait we want to avoid the mouse
	if avoid_mouse:
		var distance_to_mouse = self.position.distance_to(mouse_pos)
		
		# it's too close - run (fly?) away!
		if distance_to_mouse < 200:
			# flying away is deciding we want to fly _exactly away_
			angle_to_goal = deg2rad(180) + (mouse_pos - self.position).normalized().angle()
	
	print(rad2deg(angle_to_goal))
	
	# this is how far we can turn this step (include delta for smoothness)
	var max_turn_step = MAX_TURN * delta
	
	# so this is how hard I want to turn
	var desired_turn = abs(angle_to_goal - angle)
	
	# now break it down into how hard I can actually turn and in what direction
	var turn_dir = -1 if (angle_to_goal - angle) < 0 else 1
	if desired_turn > max_turn_step:
		desired_turn = max_turn_step
	
	# turn!
	angle += turn_dir * desired_turn
	
	# keep our angle clamped to within 0-360
	if rad2deg(angle) < 0:
		angle = deg2rad(rad2deg(angle) + 360)
	elif rad2deg(angle) > 360:
		angle = deg2rad(rad2deg(angle) - 360)
	
	# slow down when turning hard, speed up when flying straight
	if desired_turn > max_turn_step * 1/4:
		# slow down
		cvelocity -= desired_turn * 10 * delta
		cvelocity = max(MIN_SPEED, cvelocity)
	else:
		# speed up
		cvelocity += cvelocity * delta
		cvelocity = min(MAX_SPEED, cvelocity)
	
	# actually move in the direction we're going
	var move_dir = Vector2(cos(angle), sin(angle)).normalized()
	self.position += move_dir * cvelocity * delta