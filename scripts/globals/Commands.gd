extends Node

# This class handle user inputs like an API
# Updates Run state
# Tells the Events to emit presentation related signals only after state is updated

@onready var command_zone: CommandZone = State.run_state.command_zone
@onready var inventory: Inventory = State.run_state.inventory
@onready var points_of_interest: PointsOfInterest = State.run_state.points_of_interest

# Read Commands
func select_cell(coords: Coords) -> void:
	var command_zone_cell := command_zone.get_cell(coords)
	if !command_zone_cell.ship:
		return
	State.run_state.selected_cz_coords = coords
	if command_zone_cell.ship:
		CommandEvents.cz_cell_selected.emit(command_zone_cell.ship)

func select_flagship() -> void:
	var flagship := command_zone.get_flagship()
	CommandEvents.cz_cell_selected.emit(flagship)

# Write Commands
func enable_cz_cell(coords: Coords) -> void:
	command_zone.enable_cell(coords)
	CommandEvents.emit_command_zone_changed(command_zone)

func add_ship_to_cz(coords: Coords, ship: ShipData) -> void:
	# TODO: add validations
	command_zone.set_cell_ship_data(coords, ship)
	CommandEvents.emit_command_zone_changed(command_zone)

func swap_cz_cells(coords1: Coords, coords2: Coords) ->void:
	var cell1 = command_zone.get_cell(coords1)
	var cell2 = command_zone.get_cell(coords2)
	command_zone.set_cell(coords1, cell2)
	command_zone.set_cell(coords2, cell1)
	CommandEvents.emit_command_zone_changed(command_zone)

func add_weapon_to_ship(inv_idx: int, weapon_slot_idx: int) -> void:
	var weapon_data := inventory.get_item(inv_idx)
	inventory.set_item(inv_idx, null)
	var selected_cz_cell = command_zone.get_cell(State.run_state.selected_cz_coords)
	assert(selected_cz_cell.ship, "Attempt to add a weapon to a null ship instance")
	selected_cz_cell.ship.weapon_slots[weapon_slot_idx] = weapon_data
	CommandEvents.emit_inventory_changed(inventory)
	CommandEvents.emit_cz_cell_selected(selected_cz_cell.ship)
	CommandEvents.emit_ship_updated(selected_cz_cell.ship)

func add_item_to_inventory(idx: int, item_data: ItemData) -> void:
	inventory.set_item(idx, item_data)
	CommandEvents.emit_inventory_changed(inventory)

func swap_inventory_cells(idx1: int, idx2: int) -> void:
	var item1 = inventory.get_item(idx1)
	var item2 = inventory.get_item(idx2)
	inventory.set_item(idx1, item2)
	inventory.set_item(idx2, item1)
	CommandEvents.emit_inventory_changed(inventory)

func add_poi(poi_data: PoiData) -> void:
	points_of_interest.add_poi(poi_data)
	CommandEvents.emit_poi_added(poi_data)

func clear_poi(poi_data: PoiData) -> void:
	poi_data.cleared = true #TODO, does this need to interface with RunState instead of direct access here?
	CommandEvents
	
