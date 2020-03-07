extends Node2D

class_name DialogBox

var text_origin: Node2D
var profile: Sprite
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
const LINE_HEIGHT := 35
var ticker_max_value := 99999999999.9
var line1: String
var line2: String
var line3: String
var visible_line_1: String
var visible_line_2: String
var visible_line_3: String
var parser1: TextParser
var parser2: TextParser
var parser3: TextParser

func _ready():
	self.text_origin = get_node("TextOrigin")
	self.profile = get_node("Profile")
	
	self.visible_line_1 = ""
	self.visible_line_2 = ""
	self.visible_line_3 = ""
	self.ticker = -1
	
	var data = load("res://fonts/BreeSerif-Regular.ttf")
	font.font_data = data
	font.size = 24


func set_text(lines: Array): # of String
	self.line1 = lines[0]
	self.line2 = lines[1] if len(lines) > 1 else ""
	self.line3 = lines[2] if len(lines) > 2 else ""
	self.parser1 = TextParser.new(line1)
	self.parser2 = TextParser.new(line2, self.parser1.get_total_delta())
	self.parser3 = TextParser.new(line3, self.parser2.get_total_delta())
	
	var profile_image := self.parser1.profile
	if profile_image:
		self.profile.set_texture(load("res://img/dialog/"+profile_image+".png"))
		self.text_origin.position.x += 105
	else:
		self.profile.hide()

func start():
	self.ticker = 0
	self.ticker_max_value = self.parser3.get_total_delta()


func show_full() -> bool:
	# returns true if the full text was shown, false if the full text had already
	# been visible
	if self.ticker >= ticker_max_value:
		return false
	self.ticker = ticker_max_value
	return true

func _process(delta):
	if self.ticker < 0:
		return
	
	self.ticker += delta
	self.visible_line_1 = self.parser1.get_text(self.ticker)
	self.visible_line_2 = self.parser2.get_text(self.ticker)
	self.visible_line_3 = self.parser3.get_text(self.ticker)
	
	update()
	

func _draw():
	draw_string(self.font, self.text_origin.position, self.visible_line_1, Color.black)
	draw_string(self.font, self.text_origin.position + Vector2(0, LINE_HEIGHT), self.visible_line_2, Color.black)
	draw_string(self.font, self.text_origin.position + Vector2(0, LINE_HEIGHT*2), self.visible_line_3, Color.black)
	
class TextParser:
	var raw_text: String
	var token_count: int
	var parts: Array
	var initial_delay: float
	var profile: String
	
	func _init(text: String, delay: float = 0.0):
		self.raw_text = text
		self.initial_delay = delay
		self.profile = ""
		
		# some time between lines
		if self.initial_delay > 0:
			self.initial_delay += LETTER_SPEED*8
		
		self.parts = Array()
		self.parse()
		
	func parse():
		var raw_parts := self.raw_text.split("|")
		var cumulative_delay := self.initial_delay
		
		for p in raw_parts:
			var new_text: Text
			
			match p.left(1):
				'P': # define a profile; text follows next |
					self.profile = p.substr(1, len(p))
				'!': # ALL AT ONCE
					new_text = SuddenText.new(p.substr(1, len(p)), cumulative_delay)
				'_': # s l o w  t e x t
					new_text = SlowText.new(p.substr(1, len(p)), cumulative_delay)
				_: # The default case
					new_text = NormalText.new(p, cumulative_delay)
				
			if not new_text:
				continue
			
			cumulative_delay += new_text.get_time_taken()
			self.parts.append(new_text)
			
			
	func get_text(ticker_time):
		var ret := ""
		for p in parts:
			if p.delay > ticker_time:
				break
			ret += p.get_text(ticker_time)
			
		return ret
		
	func get_total_delta() -> float:
		# returns the amount of time it will take all text to display
		var ret := self.initial_delay
		for p in parts:
			ret += p.get_time_taken()
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
	
	func _init(text: String, initial_delay: float):
		self.raw_text = text
		self.delay = initial_delay
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
