extends Clickable

class_name Domorov

func handle_clicked(_event):
	var controller = get_tree().get_root().get_children()[0]
	
	# are you giving me cookies?
	if controller.active_item != null:
		if controller.active_item.id == "cookies":
			controller.set_game_state("domorov_satisfied")
			controller.inventory.remove_item(controller.active_item)
			controller.show_dialog(DialogTextPool.new([
				"|Pdomorov|Cookies!  My favorite!",
			]))
		else:
			controller.show_dialog(DialogTextPool.new([
				"|Pdomorov|I don't want that!",
			]))
	else:
		controller.show_dialog(DialogTextPool.new([
			"|Pdomorov|This is placeholder text",
		]))
