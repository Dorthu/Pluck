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
var outro: Sprite
var outroPat1: Sprite
var outroPat2: Sprite
var outroPat3: Sprite


# config these
const BETWEEN_INTERNVAL: float = 0.6
const IMAGE_INTERVAL: float = 3.0
const OUTRO_TIME: float = 10.0 # seconds

func _ready():
	intro1 = get_node("intro1")
	intro2 = get_node("intro2")
	intro3 = get_node("intro3")
	images = [
		intro1, intro2, intro3
	]
	outro = get_node("Outro")
	outroPat1 = outro.get_node("pat1")
	outroPat2 = outro.get_node("pat2")
	outroPat3 = outro.get_node("pat3")

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
	
	if cutscene == 2:
		outro.show()
		cumulativeDelta = 0

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
		for c in toLoad[imageIndex]:
			var r := load("res://scenes/rooms/"+c+".tscn")
			controller.room_map[c] = r.instance()
		loadOnNextFrame = false
		return
	
	if imageShown:
		if cumulativeDelta > lastChangeDelta + IMAGE_INTERVAL:
			images[imageIndex].hide()
			imageShown = false
			imageIndex += 1
			lastChangeDelta = cumulativeDelta
		elif imageIndex == 1:
			# this one scrolls
			var thisStep = delta * (800/IMAGE_INTERVAL)
			images[imageIndex].position += Vector2(-thisStep, 0)
	else:
		if cumulativeDelta > lastChangeDelta + BETWEEN_INTERNVAL:
			if imageIndex >= len(images):
				controller.intro_cutscene_callback(self)
				return
			# otherwise, show a new image
			images[imageIndex].show()
			loadOnNextFrame = true
			lastChangeDelta = cumulativeDelta
			imageShown = true

func process_outro(delta: float):
	# This does the animation for the outro cutscene
	var newDelta = cumulativeDelta + delta
	
	if cumulativeDelta <= 1 and newDelta > 1:
		outroPat1.show()
	elif cumulativeDelta <= OUTRO_TIME/3 and newDelta > OUTRO_TIME/3:
		outroPat1.hide()
		outroPat2.show()
	elif cumulativeDelta <= OUTRO_TIME-OUTRO_TIME/3 and newDelta > OUTRO_TIME-OUTRO_TIME/3:
		outroPat2.hide()
		outroPat3.show()
	elif cumulativeDelta > OUTRO_TIME:
		outroPat3.hide()
	
	cumulativeDelta = newDelta
	
	if cumulativeDelta < OUTRO_TIME:
		var thisStep = delta * (800/OUTRO_TIME)
		outro.position += Vector2(-thisStep, 0)
