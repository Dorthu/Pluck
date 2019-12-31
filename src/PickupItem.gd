extends Clickable

class_name PickupItem
# This class is an inventory item that is currently in the scene, and can be 
# picked up when clicked

export(String) var item_id: String
export(Texture) var item_sprite: Texture

func _on_PickupItem_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		collect()

func collect():
	var root_node = get_tree().get_root().get_children()[0]
	root_node.collect_item(item_id, item_sprite)
	get_parent().remove_child(self)

	if len(dialog_contents.lines) > 0:
		root_node.show_dialog(dialog_contents)