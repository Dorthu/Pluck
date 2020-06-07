extends Doorway

class_name FrontDoor

# This maps hints to the items you need to find.
const DIALOG_MAP := {
	"honeycomb": [
		"|Ppat_normal|I need to get something to eat on the journey.",
		"Something to keep my strength up.",
		"",
	],
	"sword_and_shield": [
		"|Ppat_normal|I need to get something to defend myself wtih.",
		"The woods can be dangerous..",
		"",
	],
	"potion": [
		"|Ppat_normal|I need to take a potion from downstairs",
		"|_. . . ",
		"Just in case I get hurt.",
	],
}

# Temporary, until there's a real ending
const YOU_WIN_TEXT := [
	"That's all for now!  Check back soon for updates, or",
	"click the link below for our dev blog!",
	"",
	"Thank you for playing!",
	"This game was made by: ",
	"",
	"Sara :: @PointyEarsIllustration on instagram",
	"Josh :: Josh Sager on YouTube",
	"Dorthu :: dorthu.com",
]

func get_signposting_text(controller) -> Array:
	var hints := [
		"|Pred_talk|Do you have everything you need?",
		"",
		"",
	]
	
	for item in DIALOG_MAP.keys():
		if not controller.inventory.has_item(item):
			hints += DIALOG_MAP[item]
	
	hints += [
		"|Pred|You should look around the house more.",
		"",
		"Talk to me if you need some help.",
	]
	
	return hints

func ready_to_go(controller) -> bool:
	for item in DIALOG_MAP.keys():
		if not controller.inventory.has_item(item):
			return false
	return true

func show_dialog(_event):
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.inventory.has_item('backpack'):
		if ready_to_go(controller):
			#controller.show_outro_cutscene()
			controller.show_dialog(Clickable.DialogTextPool.new([]+YOU_WIN_TEXT))
		else:
			controller.show_dialog(Clickable.DialogTextPool.new(
				get_signposting_text(controller)
			))
	else:
		controller.show_dialog(Clickable.DialogTextPool.new([
			"|Pred|You should get your backpack before you go."
		]))


func _on_FrontDoor_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and controller.click_should_interact(event):
		get_tree().set_input_as_handled()
		show_dialog(event)
