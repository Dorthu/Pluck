extends Node2D

class_name DialogController

var BOX := ResourceLoader.load('res://scenes/ui/DialogBox.tscn')
var BOX_POS := Vector2(100, 425)
var cur_box = null
var cur_text_pool = null # Clickable.DialogTextPool
var cur_index := -1

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
			cur_index += 1
			if cur_index < len(cur_text_pool.lines):
				show_dialog()

func new_dialog(text_pool): # Clickable.DialogTextPool
	cur_text_pool = text_pool
	cur_index = 0
	show_dialog()

func show_dialog():
	self.add_box()
	cur_box.set_text(cur_text_pool.lines[cur_index])
	cur_box.position = BOX_POS-get_viewport_transform().origin
	cur_box.start()
