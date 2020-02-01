extends Node2D

func opening_dialog():
	var controller = get_tree().get_root().get_children()[0]
	var lines := [
		"|Ppat_sad|Dad left last night, and he's not back yet.",
		"I should go after him.",
		"",
		"|Ppat_normal|I can't leave the house without my Backpack.",
	]
	var text_pool = Clickable.DialogTextPool.new(lines)
	controller.show_dialog(text_pool)
	controller.stop_camera = false
	
func _on_OpeningDialog_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		opening_dialog()
		get_parent().remove_child(self)
