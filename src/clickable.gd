extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Clickable

# These can be set in the editor
export var before_backpack: bool = false
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

func text_for_item(item_id) -> DialogTextPool:
	if item_id in item_text:
		return item_text[item_id]
	return DEFAULT_ITEM_TEXT

func show_dialog(_event):
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item == null:
		controller.show_dialog(dialog_contents)
	else:
		controller.show_dialog(text_for_item(controller.active_item.id))

func _on_Clickable_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().set_input_as_handled()
		
		# if this is flagged as being unavailable before the backpack
		# is obtained, do nothing if the backpack isn't in the inventory
		if not before_backpack:
			var controller = get_tree().get_root().get_children()[0]
			if not controller.inventory.has_item("backpack"):
				return
		
		handle_clicked(event)
		
func handle_clicked(event):
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
			
