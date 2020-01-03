extends Clickable

class_name Openable

var state1: Sprite
var state2: Sprite
var opened := false
export var item_name: String

func _ready():
	state1 = get_node("State1")
	state2 = get_node("State2")

func _on_Openable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		handle_clicked(event)
		
func handle_clicked(event):
	if opened:
		if len(lines) > 0:
			show_dialog(event)
	else:
		var controller = get_tree().get_root().get_children()[0]
		if controller.active_item == null:
			state1.hide()
			state2.show()
			opened = true
			if item_name:
				var item = get_node(item_name)
				item.show()