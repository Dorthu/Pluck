extends Clickable

class_name Openable

var state1: Sprite
var state2: Sprite
var opened := false
export var item_name: String

func _ready():
	state1 = get_node("State1")
	state2 = get_node("State2")

func open():
	state1.hide()
	state2.show()
	opened = true
	if item_name:
		var item = get_node(item_name)
		item.show()

func close():
	state1.show()
	state2.hide()
	opened = false
	if item_name:
		var item = get_node(item_name)
		if item:
			item.hide()

func _on_Openable_input_event(viewport, event, shade_idk):
	# call to parent method since these are already linked all over
	_on_Clickable_input_event(viewport, event, shade_idk)

func handle_clicked(event):
	if opened:
		if len(lines) > 0:
			show_dialog(event)
	else:
		var controller = get_tree().get_root().get_children()[0]
		if controller.active_item == null:
			open()
