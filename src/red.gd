extends Clickable

class_name Red

var controller # MasterController
var introd: bool
var intro_text := [
	"Ppat_normal|Hey red.",
	"I dreampt that something was wrong with Dad.",
	"I'm going after him.",
	"Pred|I thought something was wrong.",
	"...",
	"",
	"Pred_talk|Let me know if there's anything I can do",
	"to help you prepare.",
]

var help_texts := {
	"no_progress": [
		"Ppat_normal|Alright, I'm going.",
		"",
		"",
		"Pred_talk|You should get your backpack first.",
		"It's on the hook over there.",
	],
	"saw_backpack": [
		"Ppat_sad|The bracnh grew around my backpack.  I can't get it down.",
		"",
		"",
		"Pred|I guess it's been a while since you used it.",
		"You should look around to see if there's anything you can",
		"use to get it free.",
	],
	"empty_cup": [
		"Ppat_sad|I'm not sure how to get my backpack from the branch.",
		"",
		"",
		"Pred|Maybe a drink will help you think.  You should fill that",
		"cup with water at the sink.",
	],
	"water_cup": [
		"Ppat_normal|That branch grew around my backpack.  I'm not sure",
		"how to get it down.",
		"",
		"Pred|Maybe it would like some of that water.",
	],
}

var potion_quest_help := {
	"no_progress": [
		"Ppat_normal|Hey red, do you know if we have any good",
		"potions I can bring?",
		"",
		"Pred|Yeah, they should be downstairs.",
	],
	"door_locked": [
		"Ppat_sad|I need a potion from downstairs, but the door's",
		"locked.",
		"",
		"Pred_talk|I think your father keeps the key in the bedroom.",
		"...",
		"But don't tell him I told you that.",
		"Ppat_normal|I won't, promise!",
	],
	"door_unlocked": [
		"Ppat_normal|I got downstairs, but I can't find the potion",
		"I wnant.",
		"",
		"Pred|You should bring the one all the way on the left.  It's",
		"just what you need.",
	],
	"met_frank": [
		"Ppat_sad|Frank won't let me take a potion.  I'm not sure",
		"how to convince him that I need one.",
		"",
		"Pred|Maybe you don't need to convnice him.  Maybe you can",
		"just distract him.",
		"",
		"Pred_talk|Frank's got his vices, y'know.",
	],
	"frank_asleep": [
		"Ppat_normal|I gave Frank that bottle Dad keeps on the",
		"kitchen shelf, and he fell asleep.",
		"",
		"Pred|Sounds like him.  Can you take the potion without waking",
		"him?",
		"",
		"Ppat_normal|Y'know, I haven't tried.",
	],
}

var sword_quest_help := {
	"no_progress": [
		"Ppat_sad|What can I bring to defend myself, in case I",
		"run into something.. scary in the woods?",
		"",
		"Pred_talk|I'm sure if you look around you'll find something",
		"suitable.  We do a lot of adventuring, after all.",
	],
	"saw_sword": [
		"Ppat_normal|I want to bring the sword that's over the mantle,",
		"but I can't reach it.",
		"",
		"Pred_talk|Ah, your father's old sword.  It would serve you well.",
		"I don't remember where we left the stepstool.  It should",
		"be around here somewhere.",
	],
	"tried_stool": [
		"Ppat_sad|I need to get the sword down, but when I went to get it",
		"the domorov almost ate my stepstool!",
		"",
		"Pred_talk|I bet he's just hungry.  Find something else for him",
		"to eat.  He likes cookies, y'know.",
	],
	"has_cookies": [
		"Ppat_sad|I need to get the sword down, but when I went to get it",
		"the domorov almost ate my stepstool!",
		"",
		"Pred_talk|I bet he's just hungry.  I bet he'd like those cookies.",
	],
}

var food_quest_help := {
	"no_progress": [
		"Ppat_normal|I need to find something to eat while I'm out.",
		"",
		"",
		"Pred_talk|Have you looked in the kitchen?  There should be",
		"some food in the cabinets.",
	],
	"met_bumble": [
		"Ppat_sad|A bumblebee took the honeycomb I was going to bring",
		"on my journey.",
		"",
		"Pred|Maybe if you find something else it likes, it'll give it back.",
	],
	"has_flower": [
		"Ppat_sad|A bumblebee took the honeycomb I was going to bring",
		"on my journey.",
		"",
		"Pred|I bet it would like that flower.  You should offer it to",
		"the bumblebee - just hold it out and let the bee come to you.",
	],
}

var ready_to_go_text := [
	"Ppat_normal|I think I got everything.  I'm going to get going.",
	"Thanks for your help!",
	"",
	"Pred_talk|Good luck!  Be careful!",
	"",
	"",
	"Ppat_normal|Don't worry red, I will be.",
	"I'll be back soon.",
	"_|. . . |With dad."
]

func _ready():
	introd = false
	controller = get_tree().get_root().get_children()[0]

func say(text):
	controller.show_dialog(Clickable.DialogTextPool.new([] + text))

func get_quest_help():
	var options := []
	
	if not controller.inventory.has_item("honeycomb"):
		if controller.inventory.has_item("flower"):
			options.append(food_quest_help["has_flower"])
		elif controller.game_state_active("bumble"):
			options.append(food_quest_help["met_bumble"])
		else:
			options.append(food_quest_help["no_progress"])
	if not controller.inventory.has_item("sword_and_shield"):
		if controller.inventory.has_item('cookies'):
			options.append(sword_quest_help['has_cookies'])
		elif controller.game_state_active('hungry_fire'):
			options.append(sword_quest_help['tried_stool'])
		elif controller.game_state_active('saw_sword'):
			options.append(sword_quest_help['saw_sword'])
		else:
			options.append(sword_quest_help['no_progress'])
	if not controller.inventory.has_item("potion"):
		if controller.game_state_active("frank_asleep"):
			options.append(potion_quest_help["frank_asleep"])
		elif controller.game_state_active("met_frank"):
			options.append(potion_quest_help["met_frank"])
		elif controller.game_state_active("door_unlocked"):
			options.append(potion_quest_help["door_unlocked"])
		elif controller.game_state_active("door_locked"):
			options.append(potion_quest_help["door_locked"])
		else:
			options.append(potion_quest_help["no_progress"])
	
	return options[randi()%len(options)]
	
func help_out():
	# Red gives hints when you talk to him, based on what you've
	# done and what you stil need to do.  This mostly boils down
	# to inspecting your inventory and then selecting a text from
	# a canned set of resposnes
	if not controller.inventory.has_item("backpack"):
		if controller.inventory.has_item("water_cup"):
			say(help_texts["water_cup"])
		elif controller.inventory.has_item("cup"):
			say(help_texts["empty_cup"])
		else:
			if controller.game_state_active("saw_backpack"):
				say(help_texts["saw_backpack"])
			else:
				say(help_texts["no_progress"])
	else:
		if (not controller.inventory.has_item("honeycomb")
			or not controller.inventory.has_item("sword_and_shield")
			or not controller.inventory.has_item("potion")):
			say(get_quest_help())
		else:
			say(ready_to_go_text)

func handle_clicked(_event):
	if not introd:
		introd = true
		say(intro_text)
	else:
		help_out()
