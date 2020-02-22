extends StoolSpot

class_name LivingRoomStoolStop

var denied_text_pool := Clickable.DialogTextPool.new([
	"|Pfireguy|Hey!  A stool!  That looks tasty!",
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
	if true: # TODO
		if controller.active_item != null and controller.active_item.id == "stool":	
			stool_suggestion.hide()
			stool_sprite.show()
			controller.show_dialog(denied_text_pool, self)


func dialog_finished():
	stool_sprite.hide()
	controller.show_dialog(after_place_text_pool)
