extends Resource
class_name RunState

@export var command_zone: CommandZone
@export var inventory: Inventory

#Hardcoded for now, in the future, this should be determined in game setup
@export_storage var flagship_coords: Coords = Coords.new(2, 2) 
# TODO: this should be default set to the flagship at some point
@export_storage var selected_cz_coords: Coords
