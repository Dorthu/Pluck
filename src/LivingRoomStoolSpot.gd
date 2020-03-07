extends StoolSpot

class_name LivingRoomStoolStop

var denied_text_pool := Clickable.DialogTextPool.new([
	"|Pdomorov|Hey!  A stool!  That looks tasty!",
	"",
	"",
	"|Ppat_normal|No!  You can't eat the stool!",
])

var after_place_text_pool := Clickable.DialogTextPool.new([
	"I picked it back up before he could eat it.",
	"",
	"",
	"|Ppat_sad|I need to find something to satisfy him before I",
	"can put the stool here.",
])

func interact_with_stool():
	# if we're not allowed to put this here yet, we get some dialog
	# and then the stool goes back into our inventory
	if controller.active_item != null and controller.active_item.id == "stool":	
		if not controller.game_state_active("domorov_satisfied"):
			controller.set_game_state("hungry_fire")
			stool_suggestion.hide()
			stool_sprite.show()
			sfx.stream = stool_drop_fx[randi()%len(stool_drop_fx)]
			sfx.play()
			controller.show_dialog(denied_text_pool, self)
		else:
			# if he's cool tho we can just put it down like normal
			.interact_with_stool()
	elif controller.active_item == null and stool_present:
		# we can always take the stool back
		.interact_with_stool()


func dialog_finished():
	stool_sprite.hide()
	sfx.stream = stool_lift_fx[randi()%len(stool_lift_fx)]
	sfx.play()
	controller.show_dialog(after_place_text_pool)
