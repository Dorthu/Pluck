extends Clickable

class_name Openable

var state1: Sprite
var state2: Sprite
var opened := false

func _ready():
	state1 = get_node("State1")
	state2 = get_node("State2")
	

func _on_Openable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		handle_clicked(event)
		
func handle_clicked(event):
	if opened:
		show_dialog(event)
	else:
		state1.hide()
		state2.show()
		opened = true