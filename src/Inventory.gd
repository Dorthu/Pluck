extends Node2D

class_name Inventory

var items: Array # of InventoryItem, see below
var slots: Array # of Node2D, these are the root nodes for the inventory items to be added to
var next_slot := 0

func _ready():
	slots.append(get_node("slot0"))
	slots.append(get_node("slot1"))
	slots.append(get_node("slot2"))
	slots.append(get_node("slot3"))


func add_item(item: InventoryItem):
	items.append(item)
	slots[next_slot].add_child(item.sprite)
	next_slot += 1


class InventoryItem:
	var tex: Texture
	var id: String
	var sprite: Sprite
	
	func _init(id, tex):
		self.id = id
		self.tex = tex
		self.sprite = Sprite.new()
		self.sprite.texture = tex