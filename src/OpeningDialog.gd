extends Node2D

func opening_dialog():
	var controller = get_tree().get_root().get_children()[0]
	var lines := [
		"Dad left last night, and he's not back yet.",
		"I should go after him.",
		"",
		"I can't leave the house without my Backpack.",
	]
	var text_pool = Clickable.DialogTextPool.new(lines)
	controller.show_dialog(text_pool)