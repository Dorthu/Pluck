extends PickupItem

# This class is specific to the potion you need in the basement
# There's custom logic because it's super specific to the quest

class_name Potion

var imp: Imp

func _ready():
	imp = get_parent().get_node("Imp")

func handle_clicked(event):
	if imp.satisfied:
		.handle_clicked(event)
	else:
		if imp.popped_out:
			imp.make_demands()
		else:
			imp.pop_out()
