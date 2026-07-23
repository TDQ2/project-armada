extends Resource
class_name Inventory

@export var items: Array[ItemData]

func _init() -> void:
	items.resize(15)

func get_item(idx: int) -> ItemData:
	return items[idx]

func set_item(idx: int, item_data: ItemData) -> void:
	items[idx] = item_data

func add_item(item_data: ItemData) -> void:
	for i in items.size():
		if items[i] == null:
			items[i] = item_data
			return
	#TODO: Need to handle running out of inventory space
