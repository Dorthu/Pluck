extends Node2D

class_name CutsceneOrchestrator


# 0 - no cutscene (not set)
# 1 - intro
# 2 - outro
var cutscene_mode = 0
var controller

var started: bool = false
var cur_delta: float = 0

var intro1: Sprite
var intro2: Sprite
var intro3: Sprite


# config these
const BETWEEN_INTERNVAL: float = 0.6
const IMAGE_INTERVAL: float = 3.0

func _ready():
	intro1 = get_node("intro1")
	intro2 = get_node("intro2")
	intro3 = get_node("intro3")
	images = [
		intro1, intro2, intro3
	]

func _process(delta):
	if not started:
		return
	
	if cutscene_mode == 1:
		process_intro(delta)
	if cutscene_mode == 2:
		process_outro(delta)

func start_cutscene(cutscene: int):
	cutscene_mode = cutscene
	cur_delta = 0
	started = true

var lastChangeDelta: float = 0
var cumulativeDelta: float = 0
var imageIndex: int = 0
var imageShown: bool = false
var loadOnNextFrame: bool = false
var images: Array = []
var toLoad := [
	["living_room"],
	["kitchen"],
	["bedroom", "cellar"],
]

func process_intro(delta: float):
	cumulativeDelta += delta
	# this shows the intro cutscene while sneakily loading recourses
	# in the background
	if loadOnNextFrame:
		print("loading this frame")
		for c in toLoad[imageIndex]:
			print("Loading "+c)
			var r := load("res://scenes/rooms/"+c+".tscn")
			controller.room_map[c] = r.instance()
		loadOnNextFrame = false
		return
	
	if imageShown:
		if cumulativeDelta > lastChangeDelta + IMAGE_INTERVAL:
			print("hiding image")
			images[imageIndex].hide()
			imageShown = false
			imageIndex += 1
			lastChangeDelta = cumulativeDelta
	else:
		if cumulativeDelta > lastChangeDelta + BETWEEN_INTERNVAL:
			print("showing image")
			if imageIndex >= len(images):
				controller.intro_cutscene_callback(self)
				return
			# otherwise, show a new image
			images[imageIndex].show()
			loadOnNextFrame = true
			lastChangeDelta = cumulativeDelta
			imageShown = true

func old_process_intro(delta: float):
	# this is the condition in which the intro animation is done
	var prev_delta := cur_delta
	cur_delta += delta
	
	if prev_delta < BETWEEN_INTERNVAL and cur_delta >= BETWEEN_INTERNVAL:
		intro1.show()
	elif prev_delta < BETWEEN_INTERNVAL+IMAGE_INTERVAL and cur_delta >= BETWEEN_INTERNVAL+IMAGE_INTERVAL:
		intro1.hide()
	elif prev_delta < BETWEEN_INTERNVAL*2+IMAGE_INTERVAL and cur_delta >= BETWEEN_INTERNVAL*2+IMAGE_INTERVAL:
		intro2.show()
	elif prev_delta < BETWEEN_INTERNVAL*2+IMAGE_INTERVAL*2 and cur_delta >= BETWEEN_INTERNVAL*2+IMAGE_INTERVAL*2:
		intro2.hide()
	elif prev_delta < BETWEEN_INTERNVAL*3+IMAGE_INTERVAL*2 and cur_delta >= BETWEEN_INTERNVAL*3+IMAGE_INTERVAL*2:
		intro3.show()
	elif prev_delta < BETWEEN_INTERNVAL*3+IMAGE_INTERVAL*3 and cur_delta >= BETWEEN_INTERNVAL*3+IMAGE_INTERVAL*3:
		intro3.hide()
	elif cur_delta > BETWEEN_INTERNVAL*4+IMAGE_INTERVAL*3:
		controller.intro_cutscene_callback(self)

func process_outro(_delta: float):
	# This does the animation for the outro cutscene
	pass
