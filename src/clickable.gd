extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Clickable

export var dialog_text: String = ""

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		get_tree().get_root().get_children()[0].show_dialog(dialog_text)