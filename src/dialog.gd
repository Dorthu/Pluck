extends Node2D

class_name DialogBox

var text_origin: Node2D
var text
var visible_text
var font := DynamicFont.new()

# These are related to how the text dispalys.
# ticket is the cumulative delta of all _process calls
# LETTER_SPEED refers to how long it takes for each letter
# to appear.
var ticker: float
const LETTER_SPEED := .05

func _ready():
	self.text_origin = get_node("TextOrigin")
	self.text = ""
	self.visible_text = ""
	self.ticker = -1

	var data = load("res://fonts/BreeSerif-Regular.ttf")
	font.font_data = data
	font.size = 24


func set_text(text):
	self.text = text


func start():
	self.ticker = 0

func _process(delta):
	if self.ticker < 0:
		return
	
	self.ticker += delta
	var visible_chars = floor(self.ticker / LETTER_SPEED)
	
	if visible_chars > self.text.length():
		self.visible_text = self.text
		self.ticker = -1
		update()
	elif visible_chars > 0:
		self.visible_text = self.text.substr(0, visible_chars)
		update()
	

func _draw():
	draw_string(self.font, self.text_origin.position, self.visible_text)