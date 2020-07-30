extends Clickable

class_name Imp

var satisfied: bool
var popped_out: bool
var hidden: Sprite
var shown: Sprite
var shownSleepy: Sprite

var cur_text: int
const TEXT_POOL: Array = [
	[
		"|Pfrank_happy|Get back upstairs, boy!",
	],
	[
		"|Ppat_normal|You sure I can't get that potion?",
		"",
		"",
		"|Pfrank_happy|Yeah I'm sure.",
		"Get back upstairs.",
	],
	[
		"|Ppat_normal|I'm still down here!",
		"",
		"",
		"|Pfrank_happy|Yeah, I see ya'.",
		"",
		"I'd rather not see yeh, though.",
		"|Ppat_sad|So..",
		"Can I have that potion now?",
		"",
		"|Pfrank_nervous|No.",
	],
]

func _ready():
	satisfied = false
	popped_out = false
	hidden = get_node("hidden")
	shown = get_node("shown")
	shownSleepy = get_node("shownSleepy")
	cur_text = 0

func pop_out():
	popped_out = true
	hidden.hide()
	shown.show()
	
	say([
		"|Pfrank_nervous|Oy!  Boy, what d'you think yer doin'?",
		"",
		"",
		"|Ppat_sad|Oh, hey Frank.",
		"",
		"",
		"|Pfrank_happy|You know yer not supposed to be messing about with the",
		"potions.",
		"Get yerself out of the basement.",
		"|Ppat_sad|But Dad's missing!  I'm trying to-",
		"",
		"",
		"|Pfrank_nervous|_No. Way.|",
		"",
		"Now get lost boy!",
	])

func make_demands():
	say([
		"|Pfrank_happy|I'm not letting ya take any potions.",
		"Yer dad would be real mad at me if I did.",
		"",
		"|Ppat_normal|Can't I do anything to change your mind?",
		"",
		"",
		"|Pfrank_nervous|Uh....|!No.",
		"You couldn't even sneak it when I was sleepin'.  I'd have to'",
		"be proper passed out for you to get it without my knowin'.",
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
			"|Pfrank_sleepy|_zzzzzzzzzz",
		])

func handle_clicked(_event):
	if not popped_out:
		return
	
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.active_item:
		if controller.active_item.id == "liquor":
			say([
				"|Pfrank_nervous|Oy!  |Where'd ya get |_that|?",
				"",
				"",
				"|Ppat_normal|I found it in the kitchen.",
				"",
				"",
				"|Pfrank_nervous|Well, it ain't for you, boy!",
				"Give it here!",
				"",
				"|Ppat_normal|Uhh.. okay.",
				"",
				"",
				"|Pfrank_happy|Heh.. haven't had this in a |_long time.",
				"|_. . . ",
				"",
			], true)
			satisfied = true
			controller.inventory.remove_item(controller.active_item)
			controller.set_game_state("frank_asleep")
		elif satisfied:
			say([
				"|Pfrank_sleepy|Zzzz",
			])
		else:
			say([
				"|Pfrank_nervous|Don't ya be tryin' to bribe me.",
				"I don't want that.",
				"",
				"|Ppat_sad|What do you want then?",
				"",
				"",
				"|Pfrank_nervous|Er, nothin'.",
				"",
				"At least, nothin' a kid would have...",
			])
	else:
		talk()

func dialog_finished():
	shown.hide()
	shownSleepy.show()
	say([
		"|Pfrank_sleepy|_zzzzzzzzzz",
		"",
		"",
		"|Ppat_normal|Uh.. he just fell asleep after he drank it?",
		"Lame.",
	])
