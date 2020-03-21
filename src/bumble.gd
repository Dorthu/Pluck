extends Node2D

class_name Bumble

# The bumble avoids your mouse unless the active item is
# the one it wants; if it is, the bumble comes right to
# you ands gives you the honeycomb
var controller # The MasterController 
var room: Room

const MOVE_SPEED = 500
const MAX_SPEED := 500.0
const MAX_TURN := .2
const BASE_ACCEL := 20.0

var room_center: Vector2
var velocity := Vector2(1, 1)
var honeycomb_texture: Texture = ResourceLoader.load('res://img/kitchen/honeycomb.png')
var gave_honeycomb := false
var flown_off := false

var with_honeycomb: AnimatedSprite
var without_honeycomb: AnimatedSprite

func _ready():
	controller = get_tree().get_root().get_children()[0]
	room = get_parent()
	room_center = Vector2(room.room_width/2.0, 300)
	controller.set_game_state('bumble')
	with_honeycomb = get_node("with_honeycomb")
	without_honeycomb = get_node("no_honeycomb")


func _process(delta):
	if flown_off:
		return
	
	if gave_honeycomb:
		velocity += Vector2(1, .3) * delta
		self.position += velocity * delta
		
		if self.position.x > get_parent().room_width + 100:
			flown_off = true
		return

	# find where we want to go
	var goal := room_center # we just like buzzing around here
	var mouse_pos = room.mouse_position()
	var avoid_mouse = true
	var accel = BASE_ACCEL
	
	# maybe we want to go to the mouse instead of there
	if controller.active_item != null and controller.active_item.id == 'flower':
		avoid_mouse = false
		goal = mouse_pos
	
	var vector_to_target := goal - self.position

	var distance_to_mouse = self.position.distance_to(mouse_pos)
	
	# oh no wait we want to avoid the mouse
	if avoid_mouse:
		# it's too close - run (fly?) away!
		if distance_to_mouse < 200:
			# flying away is deciding we want to fly _exactly away_
			vector_to_target = (mouse_pos - self.position) * -1
			accel = 200 - distance_to_mouse # speed up flying away
	else:
		# are we close enough to trade?
		if distance_to_mouse < 100:
			controller.inventory.remove_item(controller.active_item)
			controller.set_active_item(null)
			controller.collect_item('honeycomb', honeycomb_texture)
			gave_honeycomb = true
			with_honeycomb.hide()
			without_honeycomb.show()
			controller.show_dialog(Clickable.DialogTextPool.new([
				"It took the flower and gave me the honeycomb.",
				"",
				"",
				"|Ppat_normal|Thank you bumblebee!",
			]))
	
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
