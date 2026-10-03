class_name RunState
extends Resource


@export var command_zone: CommandZone
@export var inventory: Inventory
@export var points_of_interest: PointsOfInterest
@export var storm_x_idx: int = 0

#Hardcoded for now, in the future, this should be determined in game setup
@export_storage var flagship_coords: Coord = Coord.new(2, 2)
# TODO: this should be default set to the flagship at some point
@export_storage var selected_cz_coords: Coord
