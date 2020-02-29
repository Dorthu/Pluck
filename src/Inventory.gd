extends Node2D

class_name Inventory

var INVENTORY_ITEM_SCENE := ResourceLoader.load("res://scenes/ui/InventoryItem.tscn")

var items: Array # of InventoryItem, see below
var slots: Array # of Node2D, these are the root nodes for the inventory items to be added to
var controller # MasterController 

func _ready():
	# TODO - maye more slots?
	slots.append(get_node("slot0"))
	slots.append(get_node("slot1"))
	slots.append(get_node("slot2"))
	slots.append(get_node("slot3"))
	slots.append(get_node("slot4"))
	slots.append(get_node("slot5"))
	slots.append(get_node("slot6"))

func make_item(item_id: String, texture: Texture) -> InventoryItem:
	var new_item = INVENTORY_ITEM_SCENE.instance()
	new_item.setup(self, item_id, texture)
	return new_item

func add_item(item: InventoryItem):
	items.append(item)
	
	# find the next inventory slot for this item
	var next_slot := -1
	for i in range(0, slots.size()):
		if slots[i].get_child_count() == 0:
			next_slot = i
			break
	
	slots[next_slot].add_child(item)
	next_slot += 1
	
func remove_item(item: InventoryItem):
	items.erase(item)
	for s in slots:
		if s.get_child(0) == item:
			s.remove_child(s.get_child(0))
			break

func has_item(name: String) -> bool:
	for c in items:
		if c is InventoryItem and c.id == name:
			return true
	return false
