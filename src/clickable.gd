extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name Clickable

# These can be set in the editor
export(Array, String) var lines: Array
var dialog_contents: DialogTextPool

func _ready():
	dialog_contents = DialogTextPool.new(lines)

func show_dialog(event):
	get_tree().get_root().get_children()[0].show_dialog(dialog_contents)


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
			