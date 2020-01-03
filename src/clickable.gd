extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Clickable

# These can be set in the editor
export(Array, String) var lines: Array
var dialog_contents: DialogTextPool
export var item_text: Dictionary;
var DEFAULT_ITEM_TEXT := DialogTextPool.new(["I can't use this here."])

func _ready():
	dialog_contents = DialogTextPool.new(lines)
	for k in item_text.keys():
		var v = item_text[k]
		if v is Array:
			item_text[k] = DialogTextPool.new(v)
		else:
			item_text[k] = DialogTextPool.new([v])

func show_dialog(event):
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item == null:
		controller.show_dialog(dialog_contents)
	else:
		if controller.active_item.id in item_text:
			print("Key found for active item!")
			controller.show_dialog(item_text[controller.active_item.id])
		else:
			controller.show_dialog(DEFAULT_ITEM_TEXT)



func _on_Clickable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		show_dialog(event)	

class DialogTextPool:
	var lines: Array # of Array of String
	
	func _init(raw_lines: Array):
		# splits lines (Array of String) into three-length arrays of Strings for use
		# in dialog boxes
		self.lines = []
		var cur_line := []
		while len(raw_lines) > 0:
			cur_line.append(raw_lines.pop_front())
			if len(cur_line) > 2:
				self.lines.append(cur_line)
				cur_line = []
		
		if len(cur_line) > 0:
			self.lines.append(cur_line)
			