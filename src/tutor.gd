extends Node2D

# The Tutor does the tutorial - get it?
class_name Tutor

var look_hint: Sprite
var click_hint: Sprite
var should_tutor := true
var started_tutor := false
var controller
var MAX_PAN: float

func _ready():
	look_hint = get_node("LookHint")
	click_hint = get_node("ClickHint")
	controller = get_tree().get_root().get_children()[0]
	MAX_PAN = (controller.get_room_width() - controller.camera.VIEWPORT_WIDTH) * -1

func dialog_finished():
	# this is called by the master scene controller when the intro
	# dialog is finished, which is cool beans for us
	look_hint.show()
	started_tutor = true

func _process(_delta):
	if not should_tutor:
		return
	
	if look_hint.visible:
		if controller.camera.pan_position <= MAX_PAN:
			look_hint.hide()
			click_hint.show()

func _input(event):
	# once they've clicked, we're done
	if not should_tutor or not started_tutor:
		return
	
	if not event is InputEventMouseButton or not event.pressed:
		return
	
	look_hint.hide()
	click_hint.hide()
	should_tutor = false
	hide()
