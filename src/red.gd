extends Clickable

class_name Red

func handle_clicked(_event):
	print("Called it")
	var controller = get_tree().get_root().get_children()[0]
	controller.show_dialog(Clickable.DialogTextPool.new([
		"Pred|I am red.  Hello."
	]))
