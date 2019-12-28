extends Node2D

class_name DialogController

var BOX := ResourceLoader.load('res://scenes/ui/DialogBox.tscn')
var BOX_POS := Vector2(100, 425)
var cur_box = null


func add_box():
	cur_box = BOX.instance()
	self.add_child(cur_box)


func remove_box():
	self.remove_child(cur_box)


func _input(event):
	if not cur_box:
		return
	
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		if not cur_box.show_full():
			remove_child(cur_box)
			cur_box.queue_free()
			cur_box = null


func show_dialog(line1: String, line2: String, line3: String):
	self.add_box()
	cur_box.set_text(line1, line2, line3)
	cur_box.start()


func _process(delta):
	if cur_box:
		cur_box.position = BOX_POS-get_viewport_transform().origin
