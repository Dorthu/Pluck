extends Node2D

class_name Inventory

var INVENTORY_ITEM_SCENE := ResourceLoader.load("res://scenes/ui/InventoryItem.tscn")

var items: Array # of InventoryItem, see below
var slots: Array # of Node2D, these are the root nodes for the inventory items to be added to
var next_slot := 0

func _ready():
	slots.append(get_node("slot0"))
	slots.append(get_node("slot1"))
	slots.append(get_node("slot2"))
	slots.append(get_node("slot3"))


func make_item(item_id: String, texture: Texture) -> InventoryItem:
	var new_item = INVENTORY_ITEM_SCENE.instance()
	new_item.setup(self, item_id, texture)
	return new_item

func add_item(item: InventoryItem):
	items.append(item)
	slots[next_slot].add_child(item)
	next_slot += 1