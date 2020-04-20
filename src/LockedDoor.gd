extends Doorway

export var unlocked_state_marker: String
export(Array, String) var locked_text
var locked_icon: Sprite
var locked_dialog_contents: Clickable.DialogTextPool
export var key_id: String
var closed_state: Sprite
var opened_state: Sprite
var known_locked := false

var open_sound = load("res://audio/fx/door_unlock.wav")
var sfx: AudioStreamPlayer

func _ready():
	._ready()
	locked_icon = get_node("Lock")
	locked_dialog_contents = Clickable.DialogTextPool.new(locked_text)
	closed_state = get_node("State1")
	opened_state = get_node("State2")
	sfx = AudioStreamPlayer.new()
	sfx.stream = open_sound
	add_child(sfx)

func is_unlocked():
	if unlocked_state_marker in controller.game_state:
		return controller.game_state[unlocked_state_marker]
	return false

func _on_Door_mouse_entered():
	if controller.should_allow_doors():
		if is_unlocked() or not known_locked:
			# you can see the arrow if this is open, or if it's
			# locked but we don't know it yet
			arrow.show()
		else:
			locked_icon.show()

func _on_Door_mouse_exited():
	arrow.hide()
	locked_icon.hide()

func _on_Door_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and controller.click_should_interact(event):
		if controller.active_item != null and controller.active_item.id == key_id:
			# unlock the door!
			get_tree().set_input_as_handled()
			controller.game_state[unlocked_state_marker] = true
			closed_state.hide()
			opened_state.show()
			controller.inventory.remove_item(controller.active_item)
			sfx.play()
			return
		
		if not controller.should_allow_doors():
			return
		
		get_tree().set_input_as_handled()
		
		if not is_unlocked():
			if locked_dialog_contents.lines[0]:
				controller.show_dialog(locked_dialog_contents)
			arrow.hide()
			locked_icon.show()
			known_locked = true
			return
		
		get_tree().get_root().get_children()[0].change_rooms(to_room, initial_camera_x)
