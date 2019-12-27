extends Area2D

class_name Doorway

export var to_room: String
var arrow: Sprite

func _ready():
	arrow = get_node("Arrow")

func _on_Door_mouse_entered():
	arrow.show()

func _on_Door_mouse_exited():
	arrow.hide()

func _on_Door_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		get_tree().get_root().get_children()[0].change_rooms(to_room)
