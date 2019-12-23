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
var text_parser: TextParser
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
	self.text_parser = TextParser.new(text)


func start():
	self.ticker = 0

func _process(delta):
	if self.ticker < 0:
		return
	
	self.ticker += delta
	self.visible_text = self.text_parser.get_text(self.ticker)
	update()
	

func _draw():
	draw_string(self.font, self.text_origin.position, self.visible_text)
	
class TextParser:
	var raw_text: String
	var token_count: int
	var parts: Array
	
	func _init(text: String):
		self.raw_text = text
		self.parse()
		
	func parse():
		var raw_parts := self.raw_text.split("|")
		var cumulative_delay := 0.0
		
		for p in raw_parts:
			var new_text: Text
			
			match p.left(1):
				'!': # ALL AT ONCE
					new_text = SuddenText.new(p.substr(1, len(p)), cumulative_delay)
				'_': # s l o w  t e x t
					new_text = SlowText.new(p.substr(1, len(p)), cumulative_delay)
				_: # The default case
					new_text = NormalText.new(p, cumulative_delay)
				
			cumulative_delay += new_text.get_time_taken()
			parts.append(new_text)
			
	func get_text(ticker_time):
		var ret := ""
		for p in parts:
			if p.delay > ticker_time:
				break
			ret += p.get_text(ticker_time)
			
		return ret

class Text:
	# Base class for all text that's parsed above.
	# Splits text into tokens and returns what it should print
	# based on its built in delay and the amount of time it takes per
	# character.
	var raw_text: String
	var tokens: Array
	var delay: float
	var letter_speed: float
	
	func _init(text: String, delay: float):
		self.raw_text = text
		self.delay = delay
		self.letter_speed = LETTER_SPEED
		self.parse()
		
	func get_time_taken():
		return len(self.tokens) * self.letter_speed
		
	func parse():
		pass
		
	func get_text(ticker_time: float):
		# ticker_time is the total time taken since the display was
		# started
		var my_time := ticker_time - self.delay
		var show_tokens := floor(my_time / self.letter_speed)
		
		var ret := ""
		
		if show_tokens > len(self.tokens):
			show_tokens = len(self.tokens)
		
		for i in range(0, show_tokens):
			ret += self.tokens[i]
		
		return ret


class NormalText extends Text:
	func _init(text: String, delay: float).(text, delay):
		pass
	
	func parse():
		self.tokens = []
		for c in self.raw_text:
			tokens.append(c)


class SlowText extends NormalText:
	func _init(text: String, delay: float).(text, delay):
		self.letter_speed = LETTER_SPEED * 6


class SuddenText extends Text:
	func _init(text: String, delay: float).(text, delay):
		self.letter_speed = LETTER_SPEED * 20
		
	func parse():
		self.tokens = [self.raw_text]