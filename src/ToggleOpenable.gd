extends Openable

export (Array, String) var close_nodes
var spawned_bee := false

func open():
	var parent = get_parent()
	for c in close_nodes:
		var node = parent.get_node(c)
		node.close()
	
	if not spawned_bee:
		spawned_bee = true
		var b = load("res://scenes/interact/bumble.tscn")
		self.get_parent().add_child(b.instance())
	
	.open()