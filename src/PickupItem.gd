extends Clickable

class_name PickupItem
# This class is an inventory item that is currently in the scene, and can be 
# picked up when clicked

export(String) var item_id: String
export(Texture) var item_sprite: Texture

func _on_PickupItem_input_event(viewport, event, shape_idx):
	# call parent function since this is already linked up everywhere
	_on_Clickable_input_event(viewport, event, shape_idx)


func handle_clicked(_event):
	var controller = get_tree().get_root().get_children()[0]
	if controller.active_item != null:
		return
	
	collect(controller)

func collect(controller):
	controller.collect_item(item_id, item_sprite)
	get_parent().remove_child(self)

	if len(dialog_contents.lines) > 0:
		controller.show_dialog(dialog_contents)
