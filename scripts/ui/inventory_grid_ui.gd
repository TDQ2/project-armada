extends GridContainer

func _ready() -> void:
	Events.inventory_changed.connect(_refresh_inventory)
	
	# test data
	Commands.add_item_to_inventory(2, Data.create_weapon(Data.WeaponType.CANNON))

func _refresh_inventory(inventory: Inventory) -> void:
	for i in inventory.items.size():
		var backend_item := inventory.get_item(i) as ItemData
		var ui_item = get_child(i) as Button
		_update_item(ui_item, backend_item)

func _update_item(ui_item: Button, backend_item: ItemData) -> void:
	if backend_item:
		ui_item.icon = backend_item.ui_icon
	else:
		ui_item.icon = null
