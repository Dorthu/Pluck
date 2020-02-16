extends Clickable

class_name Imp

var satisfied: bool
var popped_out: bool
var hidden: Sprite
var shown: Sprite

func _ready():
	satisfied = false
	popped_out = false
	hidden = get_node("hidden")
	shown = get_node("shown")

func pop_out():
	popped_out = true
	hidden.hide()
	shown.show()
	
	say([
		"|Pimp|That's mine!  You can't have it!",
	])

func make_demands():
	say([
		"|Pimp|That's mine!  You can't have it!",
	])
	
func say(lines: Array):
	var controller = get_tree().get_root().get_children()[0]
	controller.show_dialog(Clickable.DialogTextPool.new(lines))

func talk():
	say([
		"Temporary dialog!",
	])

func handle_clicked(_event):
	if not popped_out:
		return
	
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item:
		if controller.active_item.id == "liquor":
			say([
				"|Pimp|Hey!  That's my favorite drink!",
				"",
				"You can have the potion now."
			])
			satisfied = true
			controller.inventory.remove_item(controller.active_item)
		elif controller.active_item.id == "potion":
			say([
				"|Pimp|I don't want that anymore!",
			])
		else:
			say([
				"|Pimp|I don't want that!",
			])
	else:
		talk()
