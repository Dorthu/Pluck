extends PickupItem
# A PickupItem that's out of reach if a stool isn't in
# the right spot
class_name StoolOnlyPickipItem

var stool_spot: StoolSpot
export(Array, String) var no_stool_lines: Array

func _ready():
	stool_spot = get_parent().get_node("StoolSpot")


func handle_clicked(event):
	if not stool_spot.stool_present:
		var controller = get_tree().get_root().get_children()[0]
		controller.show_dialog(DialogTextPool.new(
			[]+no_stool_lines # copy the text array so we can reuse it
		))
		return
	
	.handle_clicked(event)
