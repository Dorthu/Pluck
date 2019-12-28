extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Clickable

# These can be set in the editor
export var line1: String = ""
export var line2: String = ""
export var line3: String = ""


func _on_Clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		get_tree().get_root().get_children()[0].show_dialog(line1, line2, line3)
