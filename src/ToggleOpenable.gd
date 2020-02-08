extends Openable

export (Array, String) var close_nodes
export var spawns_bumble: bool


func open():
	var parent = get_parent()
	for c in close_nodes:
		var node = parent.get_node(c)
		node.close()
		
	var controller = get_tree().get_root().get_children()[0]
	if spawns_bumble and not controller.game_state_active('bumble'):
		var b = load("res://scenes/interact/bumble.tscn")
		var bumble = b.instance()
		bumble.position = Vector2(self.position.x, self.position.y)
		self.get_parent().add_child(bumble)
		controller.show_dialog(
			Clickable.DialogTextPool.new([
				"|Ppat_normal|Oh!  That bumblebee has the honeycomb!",
				"",
				"",
				"|Ppat_sad|I was going to bring that with me.",
			])
		)
	
	.open()
