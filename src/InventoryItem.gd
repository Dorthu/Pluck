extends Node2D

class_name InventoryItem

var my_inventory # Inventory
var my_sprite: Sprite
var id: String
var my_texture: Texture

func _ready():
	my_sprite = get_node("Graphic")
	if my_texture:
		my_sprite.texture = my_texture
	
func setup(inventory, item_id: String, texture: Texture):
	my_inventory = inventory
	id = item_id
	my_texture = texture
	
	if my_sprite:
		my_sprite.texture = texture
		
func _on_InventoryItem_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		my_inventory.controller.set_active_item(self)
