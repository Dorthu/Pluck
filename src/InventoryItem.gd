extends Node2D

class_name InventoryItem

var my_inventory # Inventory
var my_sprite: Sprite
var id: String
var my_texture: Texture
var my_shader: ShaderMaterial

func _ready():
	my_sprite = get_node("Graphic")
	my_shader = my_sprite.material
	if my_texture:
		my_sprite.texture = my_texture
	
func setup(inventory, item_id: String, texture: Texture):
	my_inventory = inventory
	id = item_id
	my_texture = texture
	
	if my_sprite:
		my_sprite.texture = texture
		#my_sprite.material
		
func stop_being_active():
	my_shader.set_shader_param("on", false)

func _on_InventoryItem_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		my_inventory.controller.set_active_item(self)
		my_shader.set_shader_param("on", true)
