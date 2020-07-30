extends Clickable

class_name ConditionalClickablle

# notBefore and notAfter are GameStates that must be satisfied for this to be
# clickable - otherwise it does nothing
export var notBefore: String
export var notAfter: String
export var notHasItem: String

func handle_clicked(event):
	print("In handle clicked")
	var controller = get_tree().get_root().get_children()[0]
	
	print(notBefore)
	print(controller.game_state_active(notBefore))
	print(notAfter)
	print(controller.game_state_active(notAfter))
	
	if (notBefore == "" or controller.game_state_active(notBefore)
		and (notAfter == "" or not controller.game_state_active(notAfter))
		and (notHasItem == "" or not controller.inventory.has_item(notHasItem))):
		# only show a dialog if we're between these two game states
		show_dialog(event)
