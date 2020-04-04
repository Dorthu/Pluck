extends Area2D

# HintIcon is in charge of showing hints when moused hovered over
class_name HintIcon

var controller

func _ready():
	controller = get_parent().get_parent()

func _on_HintIcon_mouse_entered():
	controller.show_click_hints()

func _on_HintIcon_mouse_exited():
	controller.hide_click_hints()
