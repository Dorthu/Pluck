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


func _ready():
	self.add_box()


func _process(delta):
	if cur_box:
		update()


func _draw():
	if cur_box:
		cur_box.position = BOX_POS-get_viewport_transform().origin