extends Node2D

class_name Bumble

# The bumble avoids your mouse unless the active item is
# the one it wants; if it is, the bumble comes right to
# you ands gives you the honeycomb
var controller # The MasterController 

const MOVE_SPEED = 50
var room_center: Vector2

func _ready():
	controller = get_tree().get_root().get_children()[0]
	room_center = Vector2(get_parent().room_width/2, 300)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	# if I'm on the screen, what am I doing?
	if controller.active_item != null and controller.active_item.id == 'liquor':
		# go toward the mouse
		if abs(self.position.x - mouse_pos.x) > MOVE_SPEED:
			if self.position.x < mouse_pos.x:
				self.position.x += MOVE_SPEED
			else:
				self.positon.x -= MOVE_SPEED
		
		if abs(self.position.y - mouse_pos.y) > MOVE_SPEED:
			if self.position.y < mouse_pos.y:
				self.position.y += MOVE_SPEED
			else:
				self.positon.y -= MOVE_SPEED
	else:
		# if it's not near me, bumble around
		var distance := self.position.distance_to(mouse_pos)
		
		if abs(distance) < MOVE_SPEED*3:
			self.position.x += MOVE_SPEED*3
			self.position.y += MOVE_SPEED*3
		else:
			# bumble around toward the center of the screen
			if self.position.x < room_center.x:
				self.position.x += MOVE_SPEED
			elif self.position.x > room_center.x:
				self.position.x -= MOVE_SPEED
			
			if self.position.y < room_center.y:
				self.position.y += MOVE_SPEED
			elif self.position.y > room_center.y:
				self.position.y -= MOVE_SPEED