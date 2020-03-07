extends Area2D

class_name StoolSpot

var controller: MasterController
var stool_present = false
var stool_sprite: Sprite
var stool_suggestion: Sprite

export var stool_item_texture: Texture

var stool_drop_fx: Array = [
	load("res://audio/fx/stool_drop_1.wav"),
	load("res://audio/fx/stool_drop_2.wav"),
]

var stool_lift_fx: Array = [
	load("res://audio/fx/stool_lift_1.wav"),
	load("res://audio/fx/stool_lift_2.wav"),
]

var sfx: AudioStreamPlayer

func _ready():
	controller = get_tree().get_root().get_children()[0]
	stool_sprite = get_node("StoolSprite")
	stool_suggestion = get_node("StoolPlaceholder")
	sfx = AudioStreamPlayer.new()
	add_child(sfx)

func has_stool() -> bool:
	# returns True if the stool is in the inventory, otherwise
	# returns False
	return controller.inventory.has_item("stool")

func _on_StoolSpot_input_event(_viewport, event, _shape_idx):
	# when you put the stool down
	if event is InputEventMouseButton and event.pressed:
		interact_with_stool()


func interact_with_stool():
	if controller.active_item != null and controller.active_item.id == "stool":
		controller.inventory.remove_item(controller.active_item)
		stool_present = true
		stool_suggestion.hide()
		stool_sprite.show()
		sfx.stream = stool_drop_fx[randi()%len(stool_drop_fx)]
		sfx.play()
	
	if stool_present and controller.active_item == null:
		stool_present = false
		stool_sprite.hide()
		controller.collect_item("stool", stool_item_texture)
		sfx.stream = stool_lift_fx[randi()%len(stool_lift_fx)]
		sfx.play()


func _on_StoolSpot_mouse_entered():
	if stool_present or not has_stool():
		return
	stool_suggestion.show()
	
func _on_StoolSpot_mouse_exited():
	if stool_present or not has_stool():
		return
	stool_suggestion.hide()
