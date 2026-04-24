extends GridContainer

@onready var inventory := Run.inventory

func _ready() -> void:
	inventory.inventory_grid_changed.connect(_refresh_inventory)
	inventory.set_item(2, Data.create_weapon(Data.WeaponType.CANNON))

func _refresh_inventory() -> void:
	print("inventory refreshed")
	for i in inventory.items.size():
		var backend_item := inventory.get_item(i) as ItemData
		var ui_item = get_child(i) as Button
		_update_item(ui_item, backend_item)

func _update_item(ui_item: Button, backend_item: ItemData) -> void:
	if backend_item:
		ui_item.icon = backend_item.ui_icon
	else:
		ui_item.icon = null
