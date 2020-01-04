extends Openable

class_name LockedOpenable

export var required_item_id: String
export var consume_item: bool
export(Array, String) var locked_text
var locked_text_pool: Clickable.DialogTextPool

func _ready():
	._ready()
	locked_text_pool = Clickable.DialogTextPool.new(locked_text)

func handle_clicked(event):
	if opened:
		if len(lines) > 0:
			show_dialog(event)
	else:
		var controller = get_tree().get_root().get_children()[0]
		if controller.active_item != null:
			if controller.active_item.id == required_item_id:
				open()
				if consume_item:
					controller.inventory.remove_item(controller.active_item)
			else:
				controller.show_dialog(text_for_item(controller.active_item.id))
		else:
			if len(locked_text_pool.lines) > 0:
				controller.show_dialog(locked_text_pool)