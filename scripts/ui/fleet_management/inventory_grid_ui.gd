extends GridContainer

func _ready() -> void:
	CommandEvents.inventory_changed.connect(_refresh_inventory)
	
	# test data
	Commands.add_item_to_inventory_at_idx(0, Data.create_weapon(Data.WeaponType.STANDARD_CANNON))
	Commands.add_item_to_inventory_at_idx(1, Data.create_weapon(Data.WeaponType.STANDARD_CANNON))
	Commands.add_item_to_inventory_at_idx(2, Data.create_weapon(Data.WeaponType.INCENDIARY_CANNON))
	Commands.add_item_to_inventory_at_idx(3, Data.create_weapon(Data.WeaponType.INCENDIARY_CANNON))

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
