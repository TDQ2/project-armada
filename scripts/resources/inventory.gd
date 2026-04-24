extends Resource
class_name Inventory

signal inventory_grid_changed

var items: Array[ItemData]

func _init() -> void:
	items.resize(15)

func get_item(idx: int) -> ItemData:
	return items[idx]

func set_item(idx: int, item_data: ItemData) -> void:
	items[idx] = item_data
	inventory_grid_changed.emit()
