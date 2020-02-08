extends Clickable

class_name Sink

export var cup_of_water_texture: Texture
export(Array, String) var fill_cup_text
var fill_cup_text_pool: Clickable.DialogTextPool

func _ready():
	fill_cup_text_pool = Clickable.DialogTextPool.new(fill_cup_text)

func show_dialog(event):
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item != null and controller.active_item.id == 'cup':
		# fill the cup with water
		get_tree().set_input_as_handled()
		controller.inventory.remove_item(controller.active_item)
		controller.collect_item('water_cup', cup_of_water_texture)
		controller.show_dialog(fill_cup_text_pool)
		return
	
	.show_dialog(event)
