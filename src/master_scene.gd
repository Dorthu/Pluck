extends Node2D

class_name MasterController

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var s = ResourceLoader.load('res://scenes/rooms/prototype-living-room.tscn')
	get_node('ActiveScene').add_child(s.instance())
	#get_tree().get_root().get_node('ActiveScene').add_child(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
