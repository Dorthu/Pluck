extends Node2D

class_name CutsceneOrchestrator

var house: Sprite
var house_outside: Sprite
var pat_leaving: Sprite
var outro: Sprite
export(Array, Texture) var outro_textures: Array
var outro_place: int = 1

const PAT_SPEED: float = 67.0
const BG_SPEED: float = 180.0

# 0 - no cutscene (not set)
# 1 - intro
# 2 - outro
var cutscene_mode = 0
var controller

# outro vars
var anim_done: bool = false

func _ready():
	house = get_node("bg")
	house_outside = get_node("outside")
	pat_leaving = get_node("pat_leaving")
	outro = get_node("outro")
	
	setup_scene()

func _process(delta):
	if cutscene_mode == 1:
		process_intro(delta)
	if cutscene_mode == 2:
		process_outro(delta)

func setup_scene():
	if cutscene_mode == 2:
		house_outside.hide()
		pat_leaving.show()
		house.show()
		outro.texture = outro_textures[0]

func process_intro(_delta: float):
	# this is the condition in which the intro animation is done
	if pat_leaving.position.x > 1024:
		controller.intro_cutscene_callback()


func process_outro(delta: float):
	# This does the animation for the outro cutscene
	pat_leaving.position.x += PAT_SPEED * delta
	
	if house.position.x > -1 * house.texture.get_width() + 1024:
		house.position.x -= BG_SPEED * delta
		house_outside.position.x -= BG_SPEED * delta
	elif not anim_done:
		anim_done = true
		outro.show()

	if not house_outside.visible:
		if pat_leaving.position.x - house.position.x > 1250:
			house_outside.show()

func _unhandled_input(event):
	if not anim_done:
		return
	
	if not event is InputEventMouseButton or not event.pressed:
		return
	
	if outro.visible:
		if outro_place < len(outro_textures):
			outro.texture = outro_textures[outro_place]
			outro_place+=1
