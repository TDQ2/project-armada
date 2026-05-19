extends Node

# This class handle user inputs like an API
# Updates Run state
# Tells the Events to emit presentation related signals only after state is updated

@onready var command_zone: CommandZone = State.run_state.command_zone
@onready var inventory: Inventory = State.run_state.inventory

# Read Commands
func select_cell(row: int, col: int) -> void:
	var command_zone_cell := command_zone.get_cell(row, col)
	if !command_zone_cell.ship:
		return
	State.run_state.selected_cz_coords = Vector2i(row, col)
	if command_zone_cell.ship:
		Events.cz_cell_selected.emit(command_zone_cell.ship)

# Write Commands
func enable_cz_cell(row: int, col: int) -> void:
	command_zone.enable_cell(row, col)
	Events.emit_command_zone_changed(command_zone)

func add_ship_to_cz(row: int, col: int, ship: ShipData) -> void:
	# TODO: add validations
	command_zone.set_cell_ship_data(row, col, ship)
	Events.emit_command_zone_changed(command_zone)

func swap_cz_cells(row1: int, col1: int, row2: int, col2: int) ->void:
	var cell1 = command_zone.get_cell(row1, col1)
	var cell2 = command_zone.get_cell(row2, col2)
	command_zone.set_cell(row1, col1, cell2)
	command_zone.set_cell(row2, col2, cell1)
	Events.emit_command_zone_changed(command_zone)

func add_weapon_to_ship(inv_idx: int, weapon_slot_idx: int) -> void:
	var weapon_data := inventory.get_item(inv_idx)
	inventory.set_item(inv_idx, null)
	var selected_cz_cell = command_zone.get_cell(State.run_state.selected_cz_coords.x, State.run_state.selected_cz_coords.y)
	assert(selected_cz_cell.ship, "Attempt to add a weapon to a null ship instance")
	selected_cz_cell.ship.weapon_slots[weapon_slot_idx] = weapon_data
	Events.emit_inventory_changed(inventory)
	Events.emit_cz_cell_selected(selected_cz_cell.ship)
	

func add_item_to_inventory(idx: int, item_data: ItemData) -> void:
	inventory.set_item(idx, item_data)
	Events.emit_inventory_changed(inventory)

func swap_inventory_cells(idx1: int, idx2: int) -> void:
	var item1 = inventory.get_item(idx1)
	var item2 = inventory.get_item(idx2)
	inventory.set_item(idx1, item2)
	inventory.set_item(idx2, item1)
	Events.emit_inventory_changed(inventory)
