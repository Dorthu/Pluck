extends Area2D

class_name Doorway

export var to_room: String
export var initial_camera_x: float = 0
var arrow: Sprite
var controller # MasterController

func _ready():
	arrow = get_node("Arrow")
	controller = get_tree().get_root().get_children()[0]

func _on_Door_mouse_entered():
	if controller.should_allow_doors():
		arrow.show()

func _on_Door_mouse_exited():
	arrow.hide()

func _on_Door_input_event(_viewport, event, _shape_idx):
	if not controller.should_allow_doors():
		return
	
	if event is InputEventMouseButton and controller.click_should_interact(event):
		get_tree().set_input_as_handled()
		get_tree().get_root().get_children()[0].change_rooms(to_room, initial_camera_x)
