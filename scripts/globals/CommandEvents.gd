extends Node

# This class notifies when events have occurred that should update the presentation layer components

signal cz_cell_selected(ship: ShipData)
signal command_zone_changed(command_zone: CommandZone)
signal inventory_changed(inventory: Inventory)
signal ship_updated(ship_data: ShipData)

func emit_cz_cell_selected(ship: ShipData) -> void:
	cz_cell_selected.emit(ship)

func emit_command_zone_changed(command_zone: CommandZone) -> void:
	command_zone_changed.emit(command_zone)

func emit_inventory_changed(inventory: Inventory) -> void:
	inventory_changed.emit(inventory)

func emit_ship_updated(ship_data: ShipData) -> void:
	ship_updated.emit(ship_data)
