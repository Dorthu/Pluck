extends Clickable

class_name FrontDoor

func show_dialog(event):
	var controller = get_tree().get_root().get_children()[0]
	
	if controller.inventory.has_item('backpack'):
		controller.show_dialog(DialogTextPool.new([
			"That's all for now!  Check the dev blog for future updates:",
			"https://dorthu-project-blog.us-east-1.linodeobjects.com",
			"",
			"Thank you for playing!",
			"Special thanks to the following people: ",
			"",
			"Dorthu :: dorthu.com",
			"Sara :: @PointyEarsIllustration on instagram",
			"Josh :: Josh Sager on YouTube",
		]))
	else:
		controller.show_dialog(DialogTextPool.new([
			"I can't leave the house without my backpack."
		]))