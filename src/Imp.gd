extends Clickable

class_name Imp

var satisfied: bool
var popped_out: bool
var hidden: Sprite
var shown: Sprite
var shownSleepParticles: CPUParticles2D

var cur_text: int
const TEXT_POOL: Array = [
	[
		"|Pfrank_happy|Text pool entry 1",
	],
	[
		"|Pfrank_happy|Text pool entry 2",
		"Two lines for number 2",
	],
	[
		"|Pfrank_happy|Text pool entry 3",
		"Only two lines though",
		"",
		"|Ppat_normal|Why not more?",
		"",
		"",
		"|Pfrank_happy|Because.",
	],
	[
		"|Pfrank_happy|Text pool entry 4",
	],
]

func _ready():
	satisfied = false
	popped_out = false
	hidden = get_node("hidden")
	shown = get_node("shown")
	shownSleepParticles = shown.get_node("sleep")
	cur_text = 0

func pop_out():
	popped_out = true
	hidden.hide()
	shown.show()
	
	say([
		"|Pfrank_nervous|Hey!  Stop that!",
		"",
		"",
		"|Ppat_sad|Oh, hey Frank.",
		"",
		"",
		"|Pfrank_happy|You know your father doesn't want you getting into the",
		"potions.",
		"Now get out of here.",
		"|Ppat_sad|But he's missing!  I'm trying to-",
		"",
		"",
		"|Pfrank_nervous|!No |!way. ",
		"",
		"Now get lost kid.",
	])

func make_demands():
	say([
		"|Pfrank_happy|I'm not letting you take any potions.",
		"Your father would be cross with me if I did.",
		"",
		"|Ppat_normal|Can't I do anything to change your mind?",
		"",
		"",
		"|Pfrank_nervous|Hmm....|!No.",
		"You couldn't even get it while I was sleeping.",
		"I'd have to be |_really |out for you to get it.",
	])
	
func say(lines: Array, with_callback: bool = false):
	var controller = get_tree().get_root().get_children()[0]
	
	if with_callback:
		controller.show_dialog(Clickable.DialogTextPool.new(lines), self)
	else:
		controller.show_dialog(Clickable.DialogTextPool.new(lines))

func talk():
	if not satisfied:
		say(
			[] + TEXT_POOL[cur_text]
		)
		
		cur_text += 1
		if cur_text >= len(TEXT_POOL):
			cur_text = 0
	else:
		say([
			"|Pfrank_happy|_zzzzzzzzzz",
		])

func handle_clicked(_event):
	if not popped_out:
		return
	
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item:
		if controller.active_item.id == "liquor":
			say([
				"|Pfrank_nervous|!Hey!  |Where'd you get that?",
				"",
				"",
				"|Ppat_normal|I found it in the kitchen.",
				"",
				"",
				"|Pfrank_nervous|Well, it's not for kids!",
				"Give it here!",
				"",
				"|Ppat_normal|Uhh.. okay..",
				"",
				"",
				"|Pfrank_happy|Heh.. haven't had any of this in a |_long time.",
				"|_. . . ",
				"",
			], true)
			satisfied = true
			controller.inventory.remove_item(controller.active_item)
		elif satisfied:
			say([
				"|Pfrank_happy|Zzzz",
			])
		else:
			say([
				"|Pfrank_nervous|Don't try to bribe me.",
				"I don't even want that.",
				"",
				"|Ppat_sad|What do you want then?",
				"",
				"",
				"|Pfrank_nervous|Nothing!",
				"",
				"At leas, nothing a kid would have...",
			])
	else:
		talk()

func dialog_finished():
	shownSleepParticles.show()
	# TODO - change to sleeping sprite
	say([
		"|Pfrank_happy|_zzzzzzzzzz",
		"",
		"",
		"|Ppat_normal|I think he fell asleep?",
	])
